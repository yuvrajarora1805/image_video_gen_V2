<x-app-layout>
<main class="main-content position-relative max-height-vh-100 h-100 border-radius-lg">
<div class="container-fluid py-4">
    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-header pb-0">
                    <div class="d-flex align-items-center">
                        <h6 class="mb-0">Facebook/Instagram Token Generator</h6>
                    </div>
                    <p class="text-sm mt-2">Generate long-lived access tokens for Facebook and Instagram API</p>
                </div>
                <div class="card-body">
                    <!-- Instructions -->
                    <div class="alert alert-info">
                        <h6 class="text-white"><i class="fas fa-info-circle me-2"></i>How to Get a Short-Lived Token</h6>
                        <ol class="text-sm mb-0">
                            <li>Go to <a href="https://developers.facebook.com/tools/explorer/" target="_blank" class="text-white"><u>Graph API Explorer</u></a></li>
                            <li>Select your Facebook App</li>
                            <li>Click "Generate Access Token"</li>
                            <li>Select permissions: <code>instagram_basic</code>, <code>instagram_content_publish</code>, <code>pages_read_engagement</code>, <code>pages_manage_posts</code></li>
                            <li>Copy the generated token and paste it below</li>
                        </ol>
                    </div>

                    <!-- Token Generator Form -->
                    <form id="tokenGeneratorForm">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="app_id" class="form-control-label">Facebook App ID <span class="text-danger">*</span></label>
                                    <input class="form-control" type="text" id="app_id" name="app_id" placeholder="Enter your Facebook App ID" required>
                                    <small class="text-muted">Found in your Facebook App Dashboard → Settings → Basic</small>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="app_secret" class="form-control-label">Facebook App Secret <span class="text-danger">*</span></label>
                                    <input class="form-control" type="password" id="app_secret" name="app_secret" placeholder="Enter your Facebook App Secret" required>
                                    <small class="text-muted">Found in your Facebook App Dashboard → Settings → Basic</small>
                                </div>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="short_token" class="form-control-label">Short-Lived Access Token <span class="text-danger">*</span></label>
                            <textarea class="form-control" id="short_token" name="short_token" rows="3" placeholder="Paste the short-lived token from Graph API Explorer" required></textarea>
                            <small class="text-muted">This token expires in 1-2 hours</small>
                        </div>

                        <button type="submit" class="btn btn-primary btn-sm" id="generateBtn">
                            <i class="fas fa-key me-2"></i>Generate Long-Lived Token
                        </button>
                    </form>

                    <!-- Results Section -->
                    <div id="resultsSection" class="mt-4" style="display: none;">
                        <hr>
                        <h6 class="mb-3"><i class="fas fa-check-circle text-success me-2"></i>Token Generated Successfully!</h6>
                        
                        <!-- Long-Lived User Token -->
                        <div class="alert alert-success">
                            <h6 class="text-white">Long-Lived User Token (60 days)</h6>
                            <div class="input-group">
                                <input type="text" class="form-control form-control-sm" id="longLivedToken" readonly>
                                <button class="btn btn-sm btn-outline-light" type="button" onclick="copyToClipboard('longLivedToken')">
                                    <i class="fas fa-copy"></i> Copy
                                </button>
                            </div>
                            <small class="text-white">Expires in: <span id="expiresIn"></span></small>
                        </div>

                        <!-- Pages and Tokens -->
                        <div id="pagesSection"></div>
                    </div>

                    <!-- Error Section -->
                    <div id="errorSection" class="mt-4" style="display: none;">
                        <div class="alert alert-danger">
                            <h6 class="text-white"><i class="fas fa-exclamation-triangle me-2"></i>Error</h6>
                            <p class="text-white mb-0" id="errorMessage"></p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
document.getElementById('tokenGeneratorForm').addEventListener('submit', async function(e) {
    e.preventDefault();
    
    const btn = document.getElementById('generateBtn');
    const originalText = btn.innerHTML;
    btn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Generating...';
    btn.disabled = true;

    // Hide previous results/errors
    document.getElementById('resultsSection').style.display = 'none';
    document.getElementById('errorSection').style.display = 'none';

    const formData = {
        app_id: document.getElementById('app_id').value,
        app_secret: document.getElementById('app_secret').value,
        short_token: document.getElementById('short_token').value
    };

    try {
        const response = await fetch('{{ route("instagram.generate-token") }}', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'X-CSRF-TOKEN': '{{ csrf_token() }}'
            },
            body: JSON.stringify(formData)
        });

        const data = await response.json();

        if (data.success) {
            // Show long-lived token
            document.getElementById('longLivedToken').value = data.long_lived_token;
            const days = Math.floor(data.expires_in / 86400);
            document.getElementById('expiresIn').textContent = `${days} days`;

            // Show pages
            const pagesHtml = data.pages.map(page => `
                <div class="card mb-3">
                    <div class="card-body">
                        <h6><i class="fab fa-facebook text-primary me-2"></i>${page.page_name}</h6>
                        <div class="row">
                            <div class="col-md-6">
                                <small class="text-muted">Page ID:</small>
                                <div class="input-group input-group-sm mb-2">
                                    <input type="text" class="form-control" value="${page.page_id}" id="page_id_${page.page_id}" readonly>
                                    <button class="btn btn-outline-secondary" onclick="copyToClipboard('page_id_${page.page_id}')">
                                        <i class="fas fa-copy"></i>
                                    </button>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <small class="text-muted">Instagram User ID:</small>
                                <div class="input-group input-group-sm mb-2">
                                    <input type="text" class="form-control" value="${page.ig_user_id || 'Not connected'}" id="ig_id_${page.page_id}" readonly>
                                    ${page.ig_user_id ? `<button class="btn btn-outline-secondary" onclick="copyToClipboard('ig_id_${page.page_id}')"><i class="fas fa-copy"></i></button>` : ''}
                                </div>
                            </div>
                        </div>
                        <small class="text-muted">Page Access Token (Never Expires):</small>
                        <div class="input-group input-group-sm">
                            <input type="text" class="form-control" value="${page.page_token}" id="page_token_${page.page_id}" readonly>
                            <button class="btn btn-outline-secondary" onclick="copyToClipboard('page_token_${page.page_id}')">
                                <i class="fas fa-copy"></i>
                            </button>
                        </div>
                    </div>
                </div>
            `).join('');

            document.getElementById('pagesSection').innerHTML = pagesHtml;
            document.getElementById('resultsSection').style.display = 'block';
        } else {
            document.getElementById('errorMessage').textContent = data.message || 'Unknown error occurred';
            document.getElementById('errorSection').style.display = 'block';
        }
    } catch (error) {
        document.getElementById('errorMessage').textContent = 'Network error: ' + error.message;
        document.getElementById('errorSection').style.display = 'block';
    } finally {
        btn.innerHTML = originalText;
        btn.disabled = false;
    }
});

function copyToClipboard(elementId) {
    const input = document.getElementById(elementId);
    input.select();
    document.execCommand('copy');
    
    // Show feedback
    const btn = event.target.closest('button');
    const originalHtml = btn.innerHTML;
    btn.innerHTML = '<i class="fas fa-check"></i>';
    setTimeout(() => {
        btn.innerHTML = originalHtml;
    }, 1000);
}
</script>
</main>
</x-app-layout>
