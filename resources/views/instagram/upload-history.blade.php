<x-app-layout>
    <main class="main-content position-relative max-height-vh-100 h-100 border-radius-lg">
        <div class="container-fluid py-4">
            <div class="row">
                <div class="col-12">
                    <div class="card">
                        <div class="card-header pb-0">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <h5 class="mb-0">Instagram Upload History</h5>
                                    <p class="text-sm mb-0">Track all your video uploads to Instagram</p>
                                </div>
                                <div>
                                    <select class="form-select form-select-sm" id="statusFilter" onchange="filterByStatus()">
                                        <option value="all" {{ request('status') == 'all' || !request('status') ? 'selected' : '' }}>All Status</option>
                                        <option value="pending" {{ request('status') == 'pending' ? 'selected' : '' }}>Pending</option>
                                        <option value="processing" {{ request('status') == 'processing' ? 'selected' : '' }}>Processing</option>
                                        <option value="published" {{ request('status') == 'published' ? 'selected' : '' }}>Published</option>
                                        <option value="failed" {{ request('status') == 'failed' ? 'selected' : '' }}>Failed</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="card-body px-0 pt-0 pb-2">
                            @if($uploads->count() > 0)
                                <div class="table-responsive p-0">
                                    <table class="table align-items-center mb-0">
                                        <thead>
                                            <tr>
                                                <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Platform</th>
                                                <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">IDs</th>
                                                <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Video</th>
                                                <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7 ps-2">Credential</th>
                                                <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7 ps-2">Caption</th>
                                                <th class="text-center text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Status</th>
                                                <th class="text-center text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Uploaded</th>
                                                <th class="text-secondary opacity-7"></th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            @foreach($uploads as $upload)
                                                <tr>
                                                    <td class="align-middle">
                                                        <div class="d-flex align-items-center">
                                                            @if($upload->platform == 'facebook')
                                                                <i class="fab fa-facebook text-primary fa-lg me-2"></i>
                                                                <span class="text-xs font-weight-bold">Facebook</span>
                                                            @else
                                                                <i class="fab fa-instagram text-danger fa-lg me-2"></i>
                                                                <span class="text-xs font-weight-bold">Instagram</span>
                                                            @endif
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <div class="d-flex flex-column justify-content-center">
                                                            @if($upload->media_container_id)
                                                                <span class="text-xs font-weight-bold mb-1" title="Container ID">
                                                                    <i class="fas fa-box-open text-secondary me-1"></i> {{ $upload->media_container_id }}
                                                                </span>
                                                            @endif
                                                            @if($upload->instagram_post_id)
                                                                <span class="text-xs text-success mb-0" title="Post ID">
                                                                    <i class="fas fa-check-circle me-1"></i> {{ $upload->instagram_post_id }}
                                                                </span>
                                                            @else
                                                                <span class="text-xs text-secondary mb-0">-</span>
                                                            @endif
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <div class="d-flex px-2 py-1">
                                                            <div>
                                                                <video width="60" height="60" class="border-radius-lg" style="object-fit: cover;">
                                                                    <source src="{{ $upload->video_url }}" type="video/mp4">
                                                                </video>
                                                            </div>
                                                            <div class="d-flex flex-column justify-content-center ms-2">
                                                                <h6 class="mb-0 text-sm">{{ basename($upload->video_path) }}</h6>
                                                                <p class="text-xs text-secondary mb-0">{{ Str::limit($upload->video_url, 40) }}</p>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <p class="text-xs font-weight-bold mb-0">{{ $upload->credential->credential_name }}</p>
                                                        <p class="text-xs text-secondary mb-0">{{ $upload->credential->ig_user_id }}</p>
                                                    </td>
                                                    <td>
                                                        <p class="text-xs mb-0">{{ Str::limit($upload->caption, 50) }}</p>
                                                    </td>
                                                    <td class="align-middle text-center text-sm">
                                                        <span class="badge badge-sm bg-gradient-{{ $upload->status_color }}">
                                                            {{ ucfirst($upload->status) }}
                                                        </span>
                                                        @if($upload->status == 'failed' && $upload->error_message)
                                                            <div class="text-xs text-danger mt-1 text-wrap" style="max-width: 200px; margin: 0 auto;">
                                                                {{ Str::limit($upload->error_message, 50) }}
                                                                <i class="fas fa-info-circle" title="{{ $upload->error_message }}"></i>
                                                            </div>
                                                        @endif
                                                    </td>
                                                    <td class="align-middle text-center">
                                                        <span class="text-secondary text-xs font-weight-bold">
                                                            {{ $upload->created_at->diffForHumans() }}
                                                        </span>
                                                    </td>
                                                    <td class="align-middle">
                                                        @if($upload->status == 'published' && $upload->instagram_post_id)
                                                            <a href="https://www.instagram.com/p/{{ $upload->instagram_post_id }}/" 
                                                               target="_blank"
                                                               class="btn btn-link text-success text-gradient px-2 mb-0"
                                                               title="View on Instagram">
                                                                <i class="fab fa-instagram text-sm me-1"></i> View
                                                            </a>
                                                        @elseif($upload->status == 'failed')
                                                            <button class="btn btn-link text-danger text-gradient px-2 mb-0" 
                                                                    onclick="showError('{{ addslashes($upload->error_message) }}')"
                                                                    title="View Error">
                                                                <i class="fas fa-exclamation-circle text-sm me-1"></i> Error
                                                            </button>
                                                        @elseif($upload->status == 'processing')
                                                            <button class="btn btn-link text-info text-gradient px-2 mb-0" 
                                                                    onclick="checkStatus({{ $upload->id }})"
                                                                    title="Refresh Status">
                                                                <i class="fas fa-sync text-sm me-1"></i> Refresh
                                                            </button>
                                                        @endif
                                                    </td>
                                                </tr>
                                            @endforeach
                                        </tbody>
                                    </table>
                                </div>
                                
                                <!-- Pagination -->
                                <div class="d-flex justify-content-center mt-4">
                                    {{ $uploads->links() }}
                                </div>
                            @else
                                <div class="text-center py-5">
                                    <i class="fab fa-instagram fa-3x text-secondary mb-3"></i>
                                    <p class="text-secondary mb-0">No uploads yet. Start uploading videos to Instagram!</p>
                                </div>
                            @endif
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <script>
        function filterByStatus() {
            const status = document.getElementById('statusFilter').value;
            window.location.href = `{{ route('instagram.upload-history') }}?status=${status}`;
        }

        function showError(errorMessage) {
            alert('Upload Error:\n\n' + errorMessage);
        }

        function checkStatus(uploadId) {
            const btn = event.target.closest('button');
            const originalHtml = btn.innerHTML;
            btn.innerHTML = '<i class="fas fa-spinner fa-spin text-sm me-1"></i> Checking...';
            btn.disabled = true;

            fetch(`{{ url('/instagram/upload-status') }}/${uploadId}`)
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        alert(`Current Status: ${data.upload.status}\n\nRefreshing page...`);
                        location.reload();
                    } else {
                        btn.innerHTML = originalHtml;
                        btn.disabled = false;
                        alert('Error checking status');
                    }
                })
                .catch(error => {
                    btn.innerHTML = originalHtml;
                    btn.disabled = false;
                    console.error('Error:', error);
                    alert('An error occurred while checking status');
                });
        }

        // Auto-refresh processing uploads every 10 seconds
        let processingUploads = [];
        document.addEventListener('DOMContentLoaded', function() {
            // Find all processing uploads
            document.querySelectorAll('.badge.bg-gradient-info').forEach(badge => {
                const row = badge.closest('tr');
                const refreshBtn = row.querySelector('button[onclick^="checkStatus"]');
                if (refreshBtn) {
                    const uploadId = refreshBtn.getAttribute('onclick').match(/\d+/)[0];
                    processingUploads.push(uploadId);
                }
            });

            // If there are processing uploads, start auto-refresh
            if (processingUploads.length > 0) {
                console.log(`Auto-refreshing ${processingUploads.length} processing upload(s)...`);
                setInterval(() => {
                    location.reload();
                }, 10000); // Refresh every 10 seconds
            }
        });
    </script>
</x-app-layout>
