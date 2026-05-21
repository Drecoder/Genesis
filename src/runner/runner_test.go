package main

import (
	"bytes"
	"context"
	"os"
	"os/exec"
	"path/filepath"
	"runtime"
	"strings"
	"testing"
	"time"
)

func TestDynamicScriptTelemetryCapture(t *testing.T) {
	// 1. Create the temporary directory and mock file path
	tmpDir := t.TempDir()
	mockScriptPath := filepath.Join(tmpDir, "mock_deploy.sh")

	// Ensure the bash script uses clean Unix line endings (\n)
	mockScriptContent := []byte("#!/bin/bash\necho 'GENESIS_LOG: Initializing Shared VPC Subnets...'\n")

	err := os.WriteFile(mockScriptPath, mockScriptContent, 0700)
	if err != nil {
		t.Fatalf("Failed to stage mock script: %v", err)
	}

	var telemetryBuffer bytes.Buffer
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	var cmd *exec.Cmd
	if runtime.GOOS == "windows" {
		// Fix: Translate Windows paths (C:\foo\bar) to POSIX (/c/foo/bar) for Git Bash
		posixPath := filepath.ToSlash(mockScriptPath)
		if strings.HasPrefix(posixPath, "C:") || strings.HasPrefix(posixPath, "c:") {
			posixPath = "/c" + posixPath[2:]
		}

		// Run bash explicitly and pass the translated script path as an argument
		cmd = exec.CommandContext(ctx, "bash", posixPath)
	} else {
		// Production standard for Linux serverless containers
		cmd = exec.CommandContext(ctx, "/bin/bash", mockScriptPath)
	}

	cmd.Stdout = &telemetryBuffer
	cmd.Stderr = &telemetryBuffer

	if err := cmd.Run(); err != nil {
		t.Fatalf("Dynamic execution engine crashed with output [%s]: %v", telemetryBuffer.String(), err)
	}

	expectedSubnetLog := "GENESIS_LOG: Initializing Shared VPC Subnets..."
	if !bytes.Contains(telemetryBuffer.Bytes(), []byte(expectedSubnetLog)) {
		t.Errorf("Telemetry Breach: Expected log format missing from stream. Captured: %s", telemetryBuffer.String())
	}
}
