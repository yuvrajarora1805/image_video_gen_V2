<x-app-layout>
    <main class="main-content position-relative max-height-vh-100 h-100 border-radius-lg">
        <div class="container-fluid py-4">
            <div class="row">
                <div class="col-12">
                    <div class="card bg-gradient-primary border-0 shadow-lg mb-4" style="border-radius: 20px; overflow: hidden;">
                        <div class="card-body p-5">
                            <div class="row align-items-center">
                                <div class="col-lg-8">
                                    <h2 class="text-white mb-2 font-weight-bolder">Permanent Token Converter</h2>
                                    <p class="text-white opacity-8 mb-4">Convert your 1-hour Meta tokens into permanent Page tokens that never expire.</p>
                                    <div class="d-flex align-items-center">
                                        <span class="badge badge-sm bg-white text-primary px-3 py-2" style="border-radius: 10px;">
                                            <i class="fas fa-shield-alt me-1"></i> Security First
                                        </span>
                                        <span class="badge badge-sm bg-rgba-white-10 text-white px-3 py-2 ms-2" style="border-radius: 10px; background: rgba(255,255,255,0.1)">
                                            <i class="fas fa-bolt me-1"></i> Instant Conversion
                                        </span>
                                    </div>
                                </div>
                                <div class="col-lg-4 text-center mt-4 mt-lg-0">
                                    <div class="icon icon-shape bg-white shadow-lg text-center border-radius-xl p-4" style="width: 100px; height: 100px;">
                                        <i class="fab fa-facebook-f text-primary text-3xl opacity-10" style="font-size: 40px !important;"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row mt-4">
                <div class="col-lg-5">
                    <div class="card shadow-sm border-0" style="border-radius: 20px;">
                        <div class="card-header pb-0 bg-transparent">
                            <h5 class="font-weight-bolder">1. Start Conversion</h5>
                            <p class="text-sm">Paste your short-lived token from Explorer below.</p>
                        </div>
                        <div class="card-body">
                            <form action="{{ route('instagram.permanent-token') }}" method="GET">
                                <div class="form-group mb-4">
                                    <label class="form-control-label">User Access Token</label>
                                    <textarea name="token" class="form-control" rows="4" placeholder="EAAQUNI..." required style="border-radius: 12px; border: 2px solid #e9ecef;">{{ request('token') }}</textarea>
                                    <p class="text-xs text-muted mt-2">
                                        <i class="fas fa-info-circle me-1"></i> 
                                        Tokens from Graph API Explorer last for 1 hour.
                                    </p>
                                </div>

                                @if(!env('FACEBOOK_CLIENT_ID') || !env('FACEBOOK_CLIENT_SECRET') || env('FACEBOOK_CLIENT_SECRET') == 'PASTE_YOUR_SECRET_HERE')
                                <div class="alert alert-warning border-0 p-3 mb-4" style="border-radius: 12px; background-color: #fff8e1;">
                                    <div class="d-flex">
                                        <i class="fas fa-exclamation-triangle text-warning mt-1 me-3"></i>
                                        <div>
                                            <h6 class="text-warning font-weight-bolder mb-1">Credentials Missing</h6>
                                            <p class="text-xs text-dark mb-0">Please fill your <b>App ID</b> and <b>Secret</b> in the <code>.env</code> file first.</p>
                                        </div>
                                    </div>
                                </div>
                                @endif

                                <button type="submit" class="btn btn-primary w-100 py-3 mb-0" style="border-radius: 12px; font-weight: 700;">
                                    Get Permanent Tokens <i class="fas fa-arrow-right ms-2"></i>
                                </button>
                            </form>
                        </div>
                    </div>
                    
                    <div class="card mt-4 shadow-sm border-0 bg-dark" style="border-radius: 20px;">
                        <div class="card-body p-4">
                            <h6 class="text-white mb-3 font-weight-bolder">How it works?</h6>
                            <div class="d-flex mb-3">
                                <div class="bg-primary text-white rounded-circle p-2 me-3 d-flex align-items-center justify-content-center" style="width: 24px; height: 24px; font-size: 10px;">1</div>
                                <p class="text-white text-xs opacity-8 mb-0">The system exchanges your short token for a 60-day Long-Lived Token.</p>
                            </div>
                            <div class="d-flex mb-3">
                                <div class="bg-primary text-white rounded-circle p-2 me-3 d-flex align-items-center justify-content-center" style="width: 24px; height: 24px; font-size: 10px;">2</div>
                                <p class="text-white text-xs opacity-8 mb-0">It then fetches "me/accounts" which returns Permanent tokens for all your pages.</p>
                            </div>
                            <div class="d-flex">
                                <div class="bg-primary text-white rounded-circle p-2 me-3 d-flex align-items-center justify-content-center" style="width: 24px; height: 24px; font-size: 10px;">3</div>
                                <p class="text-white text-xs opacity-8 mb-0">Copy the permanent token to your Credentials page to save it forever.</p>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-lg-7 mt-4 mt-lg-0">
                    <div class="card shadow-sm border-0" style="border-radius: 20px; min-height: 400px;">
                        <div class="card-header pb-0 bg-transparent d-flex justify-content-between align-items-center">
                            <div>
                                <h5 class="font-weight-bolder">2. Conversion Results</h5>
                                <p class="text-sm">Found <span id="pageCount" class="font-weight-bolder text-primary">{{ isset($results['permanent_page_tokens']) ? count($results['permanent_page_tokens']) : 0 }}</span> connected pages.</p>
                            </div>
                            @if(isset($results))
                            <span class="badge bg-light text-success border border-success px-3 py-2" style="border-radius: 8px;">
                                <i class="fas fa-check-circle me-1"></i> Success
                            </span>
                            @endif
                        </div>
                        <div class="card-body pt-0">
                            @if(isset($error))
                            <div class="text-center py-5">
                                <div class="bg-light rounded-circle p-4 d-inline-flex mb-3">
                                    <i class="fas fa-times text-danger" style="font-size: 30px;"></i>
                                </div>
                                <h6 class="text-danger font-weight-bolder">{{ $error }}</h6>
                                <p class="text-sm text-muted">Please check your token or .env file</p>
                            </div>
                            @elseif(!isset($results))
                            <div class="text-center py-5 opacity-4">
                                <div class="bg-light rounded-circle p-4 d-inline-flex mb-3">
                                    <i class="fas fa-plug text-primary" style="font-size: 30px;"></i>
                                </div>
                                <h6 class="font-weight-bolder">No Data Processed</h6>
                                <p class="text-sm">Input your token and click the button to start.</p>
                            </div>
                            @else
                                <div class="table-responsive">
                                    <table class="table align-items-center mb-0">
                                        <thead>
                                            <tr>
                                                <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Page Name / ID</th>
                                                <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7 ps-2 text-center">Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            @foreach($results['permanent_page_tokens'] as $page)
                                            <tr>
                                                <td>
                                                    <div class="d-flex px-2 py-1">
                                                        <div>
                                                            <div class="avatar avatar-sm bg-gradient-info me-3" style="border-radius: 10px;">
                                                                <i class="fas fa-flag text-white"></i>
                                                            </div>
                                                        </div>
                                                        <div class="d-flex flex-column justify-content-center text-start">
                                                            <h6 class="mb-0 text-sm font-weight-bolder">{{ $page['page_name'] }}</h6>
                                                            <p class="text-xs text-secondary mb-0">ID: {{ $page['facebook_page_id'] }}</p>
                                                            <p class="text-xs font-weight-bold text-primary mb-0">IG ID: {{ $page['instagram_business_id'] }}</p>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td class="align-middle text-center">
                                                    <div class="d-flex flex-column gap-2">
                                                        <button type="button" class="btn btn-outline-primary btn-sm mb-0 copy-btn" 
                                                                data-token="{{ $page['permanent_access_token'] }}"
                                                                data-page="{{ $page['page_name'] }}"
                                                                style="border-radius: 8px;">
                                                            <i class="far fa-copy me-2"></i> Copy Permanent Token
                                                        </button>
                                                        <button type="button" class="btn btn-outline-info btn-xs mb-0 copy-btn-id" 
                                                                data-id="{{ $page['instagram_business_id'] }}"
                                                                style="border-radius: 8px; font-size: 10px;">
                                                            <i class="far fa-copy me-1"></i> Copy IG ID
                                                        </button>
                                                    </div>
                                                </td>
                                            </tr>
                                            @endforeach
                                        </tbody>
                                    </table>
                                </div>
                            @endif
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    @push('js')
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Robust Copy Function
            const copyToClipboard = (text, element) => {
                if (!text) return;
                
                // Try modern API
                if (navigator.clipboard && window.isSecureContext) {
                    navigator.clipboard.writeText(text).then(() => {
                        showSuccess(element);
                    }).catch(err => {
                        fallbackCopy(text, element);
                    });
                } else {
                    fallbackCopy(text, element);
                }
            };

            const fallbackCopy = (text, element) => {
                const textArea = document.createElement("textarea");
                textArea.value = text;
                textArea.style.position = "fixed";
                textArea.style.left = "-999999px";
                textArea.style.top = "-999999px";
                document.body.appendChild(textArea);
                textArea.focus();
                textArea.select();
                try {
                    document.execCommand('copy');
                    showSuccess(element);
                } catch (err) {
                    console.error('Fallback copy failed', err);
                }
                document.body.removeChild(textArea);
            };

            const showSuccess = (element) => {
                const originalHtml = element.innerHTML;
                element.innerHTML = '<i class="fas fa-check me-2"></i> Copied!';
                element.classList.remove('btn-outline-primary', 'btn-outline-info');
                element.classList.add('btn-success', 'text-white');
                
                setTimeout(() => {
                    element.innerHTML = originalHtml;
                    element.classList.remove('btn-success', 'text-white');
                    element.classList.add('btn-outline-primary');
                }, 2000);
            };

            // Token Buttons
            document.querySelectorAll('.copy-btn').forEach(btn => {
                btn.addEventListener('click', function() {
                    const token = this.getAttribute('data-token');
                    copyToClipboard(token, this);
                });
            });

            // ID Buttons
            document.querySelectorAll('.copy-btn-id').forEach(btn => {
                btn.addEventListener('click', function() {
                    const id = this.getAttribute('data-id');
                    copyToClipboard(id, this);
                });
            });
        });
    </script>
    @endpush

    <style>
        .bg-rgba-white-10 {
            background-color: rgba(255, 255, 255, 0.15);
        }
        .form-control:focus {
            border-color: #5e72e4 !important;
            box-shadow: 0 0 10px rgba(94, 114, 228, 0.2);
        }
        .copy-btn {
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }
        .copy-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(94, 114, 228, 0.3);
        }
    </style>
</x-app-layout>
