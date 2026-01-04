<x-app-layout>
    <main class="main-content position-relative max-height-vh-100 h-100 border-radius-lg">
        <div class="container-fluid py-4">
            <div class="row">
                <div class="col-12">
                    <div class="card">
                        <div class="card-header pb-0">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <h6 class="mb-0">Facebook Page Token Fetcher</h6>
                                    <p class="text-sm mb-0">Get long-lived page access tokens from your user access token</p>
                                </div>
                            </div>
                        </div>
                        <div class="card-body">
                            <!-- Input Form -->
                            <div class="row">
                                <div class="col-12">
                                    <div class="mb-3">
                                        <label for="userAccessToken" class="form-label">User Access Token</label>
                                        <textarea class="form-control" 
                                                  id="userAccessToken" 
                                                  rows="3" 
                                                  placeholder="Paste your Facebook user access token here..."></textarea>
                                        <small class="text-muted">This should be a long-lived user access token from Facebook</small>
                                    </div>
                                    
                                    <button type="button" 
                                            class="btn btn-primary" 
                                            id="fetchPagesBtn">
                                        <i class="fab fa-facebook me-1"></i> Fetch Page Tokens
                                    </button>
                                </div>
                            </div>

                            <!-- Loading Indicator -->
                            <div id="loadingIndicator" class="text-center my-4" style="display: none;">
                                <div class="spinner-border text-primary" role="status">
                                    <span class="visually-hidden">Loading...</span>
                                </div>
                                <p class="mt-2 text-sm">Fetching page tokens...</p>
                            </div>

                            <!-- Results -->
                            <div id="resultsContainer" class="mt-4" style="display: none;">
                                <hr>
                                <h6 class="mb-3">Page Access Tokens</h6>
                                <div id="pagesResults"></div>
                            </div>

                            <!-- Error Display -->
                            <div id="errorContainer" class="alert alert-danger mt-4" style="display: none;">
                                <strong>Error:</strong> <span id="errorMessage"></span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <script>
        document.getElementById('fetchPagesBtn').addEventListener('click', function() {
            const token = document.getElementById('userAccessToken').value.trim();
            
            if (!token) {
                showError('Please enter a user access token');
                return;
            }

            // Hide previous results/errors
            document.getElementById('resultsContainer').style.display = 'none';
            document.getElementById('errorContainer').style.display = 'none';
            document.getElementById('loadingIndicator').style.display = 'block';

            // Make API request
            fetch('{{ route("instagram.fetch-page-tokens") }}', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]').content
                },
                body: JSON.stringify({ access_token: token })
            })
            .then(response => response.json())
            .then(data => {
                document.getElementById('loadingIndicator').style.display = 'none';
                
                if (data.success) {
                    displayResults(data.pages);
                } else {
                    showError(data.message || 'Failed to fetch page tokens');
                }
            })
            .catch(error => {
                document.getElementById('loadingIndicator').style.display = 'none';
                showError('Network error: ' + error.message);
            });
        });

        function displayResults(pages) {
            const container = document.getElementById('pagesResults');
            container.innerHTML = '';

            if (!pages || pages.length === 0) {
                container.innerHTML = '<p class="text-muted">No pages found for this account.</p>';
                document.getElementById('resultsContainer').style.display = 'block';
                return;
            }

            pages.forEach(page => {
                const card = document.createElement('div');
                card.className = 'card mb-3';
                card.innerHTML = `
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-start">
                            <div>
                                <h6 class="mb-1">${page.name}</h6>
                                <p class="text-xs text-muted mb-2">Page ID: ${page.id}</p>
                                <p class="text-xs mb-2"><strong>Category:</strong> ${page.category}</p>
                            </div>
                            <button class="btn btn-sm btn-outline-primary copy-btn" 
                                    data-token="${page.access_token}"
                                    title="Copy token">
                                <i class="fas fa-copy"></i> Copy Token
                            </button>
                        </div>
                        <div class="mt-2">
                            <label class="form-label text-xs mb-1">Page Access Token:</label>
                            <textarea class="form-control form-control-sm font-monospace" 
                                      rows="3" 
                                      readonly>${page.access_token}</textarea>
                        </div>
                    </div>
                `;
                container.appendChild(card);
            });

            // Add copy functionality
            document.querySelectorAll('.copy-btn').forEach(btn => {
                btn.addEventListener('click', function() {
                    const token = this.getAttribute('data-token');
                    navigator.clipboard.writeText(token).then(() => {
                        const originalText = this.innerHTML;
                        this.innerHTML = '<i class="fas fa-check"></i> Copied!';
                        this.classList.remove('btn-outline-primary');
                        this.classList.add('btn-success');
                        
                        setTimeout(() => {
                            this.innerHTML = originalText;
                            this.classList.remove('btn-success');
                            this.classList.add('btn-outline-primary');
                        }, 2000);
                    });
                });
            });

            document.getElementById('resultsContainer').style.display = 'block';
        }

        function showError(message) {
            document.getElementById('errorMessage').textContent = message;
            document.getElementById('errorContainer').style.display = 'block';
        }
    </script>

    <style>
        .main-content {
            transition: margin-left .3s ease;
        }

        @media (min-width: 1200px) {
            .main-content {
                margin-left: 17.125rem;
            }
        }

        @media (max-width: 1199px) {
            .main-content {
                margin-left: 0;
            }
        }
    </style>
</x-app-layout>

<meta name="csrf-token" content="{{ csrf_token() }}">
