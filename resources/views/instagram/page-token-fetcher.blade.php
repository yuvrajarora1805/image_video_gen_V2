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
                                <div class="d-flex justify-content-between align-items-center mb-3">
                                    <h6 class="mb-0">Page Access Tokens</h6>
                                    <span id="totalPagesCount" class="badge bg-primary"></span>
                                </div>
                                <div id="pagesResults"></div>
                                
                                <!-- Raw API Response -->
                                <div class="mt-4">
                                    <div class="card">
                                        <div class="card-header p-3 cursor-pointer" data-bs-toggle="collapse" data-bs-target="#rawResponse">
                                            <div class="d-flex justify-content-between align-items-center">
                                                <h6 class="mb-0">
                                                    <i class="fas fa-code me-2"></i>Raw API Response
                                                </h6>
                                                <i class="fas fa-chevron-down"></i>
                                            </div>
                                        </div>
                                        <div id="rawResponse" class="collapse">
                                            <div class="card-body">
                                                <pre id="rawJsonData" class="bg-light p-3 rounded" style="max-height: 400px; overflow-y: auto;"></pre>
                                                <button class="btn btn-sm btn-outline-secondary mt-2" id="copyJsonBtn">
                                                    <i class="fas fa-copy me-1"></i>Copy JSON
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
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
                    displayRawJson(data);
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

            // Display total count
            document.getElementById('totalPagesCount').textContent = `${pages.length} Page${pages.length > 1 ? 's' : ''} Found`;

            pages.forEach((page, index) => {
                const card = document.createElement('div');
                card.className = 'card mb-3';
                
                // Build tasks/permissions HTML
                let tasksHtml = '';
                if (page.tasks && Array.isArray(page.tasks) && page.tasks.length > 0) {
                    tasksHtml = `
                        <div class="mt-2">
                            <label class="form-label text-xs mb-1"><strong>Page Permissions/Tasks:</strong></label>
                            <div class="d-flex flex-wrap gap-1">
                                ${page.tasks.map(task => `<span class="badge bg-info text-xs">${task}</span>`).join('')}
                            </div>
                        </div>
                    `;
                }
                
                card.innerHTML = `
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <div>
                                <h6 class="mb-1">
                                    <i class="fab fa-facebook-square text-primary me-1"></i>${page.name}
                                </h6>
                                <p class="text-xs text-muted mb-0">Page ID: <code>${page.id}</code></p>
                            </div>
                            <span class="badge bg-gradient-primary">#${index + 1}</span>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-6">
                                <p class="text-xs mb-2">
                                    <strong>Category:</strong> 
                                    <span class="badge bg-secondary">${page.category || 'Unknown'}</span>
                                </p>
                            </div>
                        </div>
                        
                        ${tasksHtml}
                        
                        ${page.ig_business_account_id ? `
                        <div class="mt-3">
                            <div class="d-flex justify-content-between align-items-center mb-1">
                                <label class="form-label text-xs mb-0"><strong>Instagram Business Account ID:</strong></label>
                                <button class="btn btn-sm btn-outline-info copy-btn" 
                                        data-token="${page.ig_business_account_id}"
                                        title="Copy IG ID">
                                    <i class="fas fa-copy"></i> Copy IG ID
                                </button>
                            </div>
                            <input type="text" class="form-control form-control-sm font-monospace" 
                                   value="${page.ig_business_account_id}" 
                                   readonly>
                            <small class="text-xs text-info"><i class="fas fa-info-circle me-1"></i>Link this in your Credentials to upload Instagram Reels.</small>
                        </div>
                        ` : ''}

                        <div class="mt-3">
                            <div class="d-flex justify-content-between align-items-center mb-1">
                                <label class="form-label text-xs mb-0"><strong>Page Access Token:</strong></label>
                                <button class="btn btn-sm btn-outline-primary copy-btn" 
                                        data-token="${page.access_token}"
                                        title="Copy token">
                                    <i class="fas fa-copy"></i> Copy Token
                                </button>
                            </div>
                            <textarea class="form-control form-control-sm font-monospace" 
                                      rows="3" 
                                      readonly>${page.access_token}</textarea>
                        </div>
                        
                        <!-- Collapsible Full Page Data -->
                        <div class="mt-3">
                            <button class="btn btn-sm btn-link text-decoration-none p-0" 
                                    type="button" 
                                    data-bs-toggle="collapse" 
                                    data-bs-target="#pageData${index}">
                                <i class="fas fa-chevron-down me-1"></i>View All Page Data
                            </button>
                            <div class="collapse mt-2" id="pageData${index}">
                                <pre class="bg-light p-2 rounded text-xs" style="max-height: 200px; overflow-y: auto;">${JSON.stringify(page, null, 2)}</pre>
                            </div>
                        </div>
                    </div>
                `;
                container.appendChild(card);
            });

            // Add copy functionality for tokens
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

        function displayRawJson(data) {
            const rawJsonElement = document.getElementById('rawJsonData');
            rawJsonElement.textContent = JSON.stringify(data, null, 2);
            
            // Add copy JSON functionality
            document.getElementById('copyJsonBtn').addEventListener('click', function() {
                const jsonText = rawJsonElement.textContent;
                navigator.clipboard.writeText(jsonText).then(() => {
                    const originalText = this.innerHTML;
                    this.innerHTML = '<i class="fas fa-check me-1"></i>Copied!';
                    this.classList.remove('btn-outline-secondary');
                    this.classList.add('btn-success');
                    
                    setTimeout(() => {
                        this.innerHTML = originalText;
                        this.classList.remove('btn-success');
                        this.classList.add('btn-outline-secondary');
                    }, 2000);
                });
            });
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

        .cursor-pointer {
            cursor: pointer;
        }

        #rawJsonData {
            font-size: 0.75rem;
            line-height: 1.4;
            color: #333;
        }

        .font-monospace {
            font-family: 'Courier New', Courier, monospace;
        }

        .gap-1 {
            gap: 0.25rem;
        }
    </style>
</x-app-layout>

<meta name="csrf-token" content="{{ csrf_token() }}">
