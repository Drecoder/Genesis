package genesis

import (
	"context"
	"fmt"
	"net/http"
	"time"
)

// Client represents the gateway boundary into the Genesis core engine orchestrator.
type Client struct {
	HostURL    string
	HTTPClient *http.Client
	Token      string
}

// SpokePayload represents the core DDD data contract for managing isolation boundaries.
type SpokePayload struct {
	ID          string `json:"id,omitempty"`
	Name        string `json:"name"`
	Cloud       string `json:"cloud"`
	Environment string `json:"environment"`
}

// NewClient initializes the centralized client structure with optimized timeouts.
func NewClient(hostURL, token string) (*Client, error) {
	if hostURL == "" {
		return nil, fmt.Errorf("client configuration error: host URL cannot be empty")
	}

	return &Client{
		HostURL: hostURL,
		Token:   token,
		HTTPClient: &http.Client{
			Timeout: 30 * time.Second,
		},
	}, nil
}

// GetSpoke retrieves an active isolation context from the Genesis engine.
func (c *Client) GetSpoke(ctx context.Context, spokeID string) (*SpokePayload, error) {
	if spokeID == "" {
		return nil, fmt.Errorf("invalid identity constraint: spoke ID cannot be empty")
	}

	// This mock returns a deterministic model for our upcoming data model unit tests.
	// In Phase 2, this will execute real HTTP requests authenticated via the short-lived token.
	return &SpokePayload{
		ID:          spokeID,
		Name:        "mock-spoke-context",
		Cloud:       "aws",
		Environment: "dev",
	}, nil
}

// CreateSpoke requests the allocation of a brand new multi-cloud workload landing zone.
func (c *Client) CreateSpoke(ctx context.Context, spoke SpokePayload) (*SpokePayload, error) {
	if spoke.Name == "" || spoke.Cloud == "" || spoke.Environment == "" {
		return nil, fmt.Errorf("invariant failure: payload fields 'name', 'cloud', and 'environment' are strictly required")
	}

	// Mocking successful generation of an identity key
	return &SpokePayload{
		ID:          fmt.Sprintf("spk-%s-%s", spoke.Cloud, spoke.Environment),
		Name:        spoke.Name,
		Cloud:       spoke.Cloud,
		Environment: spoke.Environment,
	}, nil
}
