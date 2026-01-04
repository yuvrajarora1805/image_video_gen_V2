<x-app-layout>
    <main class="main-content position-relative max-height-vh-100 h-100 border-radius-lg">
        <div class="container-fluid py-4">
            <div class="row">
                <div class="col-12">
                    <div class="card">
                        <div class="card-header pb-0">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <h5 class="mb-0">Send Videos to Instagram</h5>
                                    <p class="text-sm mb-0">Select a customer and send their videos to Instagram</p>
                                </div>
                            </div>
                        </div>
                        <div class="card-body px-0 pt-0 pb-2">
                            @if($customers->count() > 0)
                                <!-- Search Input -->
                                <div class="px-3 pb-3">
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="fas fa-search"></i></span>
                                        <input type="text" 
                                               class="form-control" 
                                               id="customerSearch" 
                                               placeholder="Search by customer name or email...">
                                    </div>
                                </div>
                                <div class="table-responsive p-0">
                                    <table class="table align-items-center mb-0">
                                        <thead>
                                            <tr>
                                                <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Customer</th>
                                                <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7 ps-2">Instagram Credentials</th>
                                                <th class="text-center text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Pending Videos</th>
                                                <th class="text-center text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Last Upload</th>
                                                <th class="text-secondary opacity-7"></th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            @foreach($customers as $customer)
                                                <tr>
                                                    <td>
                                                        <div class="d-flex px-2 py-1">
                                                            <div>
                                                                <div class="avatar avatar-sm me-3 bg-gradient-primary">
                                                                    <span class="text-white text-xs">{{ strtoupper(substr($customer->name, 0, 2)) }}</span>
                                                                </div>
                                                            </div>
                                                            <div class="d-flex flex-column justify-content-center">
                                                                <h6 class="mb-0 text-sm">{{ $customer->name }}</h6>
                                                                <p class="text-xs text-secondary mb-0">{{ $customer->email }}</p>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        @php
                                                            $credentials = $customer->instagramCredentials()->where('is_active', true)->get();
                                                        @endphp
                                                        @if($credentials->count() > 0)
                                                            @foreach($credentials as $cred)
                                                                <span class="badge badge-sm bg-gradient-success mb-1">{{ $cred->credential_name }}</span>
                                                            @endforeach
                                                        @else
                                                            <span class="badge badge-sm bg-gradient-warning">No Credentials</span>
                                                        @endif
                                                    </td>
                                                    <td class="align-middle text-center">
                                                        @php
                                                            // Count unsent videos for this specific customer
                                                            $pendingVideos = \App\Models\GeneratedVideo::where('customer_id', $customer->id)
                                                                ->where('sent', 0)
                                                                ->count();
                                                        @endphp
                                                        <span class="text-secondary text-sm font-weight-bold">{{ $pendingVideos }}</span>
                                                    </td>
                                                    <td class="align-middle text-center">
                                                        @php
                                                            $lastUpload = \App\Models\InstagramUploadLog::whereHas('credential', function($q) use ($customer) {
                                                                $q->where('customer_id', $customer->id);
                                                            })->latest()->first();
                                                        @endphp
                                                        <span class="text-secondary text-xs font-weight-bold">
                                                            {{ $lastUpload ? $lastUpload->created_at->diffForHumans() : 'Never' }}
                                                        </span>
                                                    </td>
                                                    <td class="align-middle">
                                                        @if($credentials->count() > 0)
                                                            <button class="btn btn-sm btn-primary" 
                                                                    onclick="openSendModal({{ $customer->id }}, '{{ $customer->name }}')"
                                                                    title="Send Videos">
                                                                <i class="fab fa-instagram me-1"></i> Send to Instagram
                                                            </button>
                                                        @else
                                                            <a href="{{ route('instagram.credentials') }}" class="btn btn-sm btn-outline-primary">
                                                                <i class="fas fa-plus me-1"></i> Add Credentials
                                                            </a>
                                                        @endif
                                                    </td>
                                                </tr>
                                            @endforeach
                                        </tbody>
                                    </table>
                                </div>
                            @else
                                <div class="text-center py-5">
                                    <i class="fas fa-users fa-3x text-secondary mb-3"></i>
                                    <p class="text-secondary mb-0">No customers found. <a href="{{ route('createuser') }}">Create a customer</a> to get started.</p>
                                </div>
                            @endif
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <!-- Send to Instagram Modal -->
    <div class="modal fade" id="sendToInstagramModal" tabindex="-1" aria-labelledby="sendToInstagramModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="sendToInstagramModalLabel">
                        <i class="fab fa-instagram me-2"></i>Send Videos to Instagram
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" id="selectedCustomerId">
                    
                    <!-- Customer Info -->
                    <div class="alert alert-info mb-3">
                        <strong>Customer:</strong> <span id="customerNameDisplay"></span>
                    </div>

                    <!-- Credential Selection -->
                    <div class="mb-3">
                        <label for="selectedCredential" class="form-label">Select Instagram Account</label>
                        <select class="form-select" id="selectedCredential" required>
                            <option value="">Choose an account...</option>
                        </select>
                    </div>

                    <!-- Platform Selection -->
                    <div class="mb-3">
                        <label for="selectedPlatform" class="form-label">Upload Platform</label>
                        <select class="form-select" id="selectedPlatform" required>
                            <option value="instagram">Instagram Only</option>
                            <option value="facebook">Facebook Only</option>
                            <option value="both">Both Instagram & Facebook</option>
                        </select>
                        <small class="text-muted">Note: Facebook requires Page ID to be configured in credentials</small>
                    </div>

                    <!-- Caption -->
                    <div class="mb-3">
                        <label for="uploadCaption" class="form-label">Caption (Optional)</label>
                        <textarea class="form-control" id="uploadCaption" rows="3" 
                                  placeholder="Write a caption for the reels..." maxlength="2200"></textarea>
                        <small class="text-muted"><span id="uploadCaptionCount">0</span>/2200 characters</small>
                    </div>

                    <!-- Video Tasks Selection -->
                    <div class="mb-3">
                        <label class="form-label">Select Video Tasks to Upload</label>
                        <div id="videoTasksList" class="row">
                            <!-- Tasks will be loaded here -->
                        </div>
                    </div>

                    <!-- Upload Progress -->
                    <div id="uploadProgressContainer" style="display: none;" class="mt-3">
                        <div class="progress mb-2">
                            <div class="progress-bar progress-bar-striped progress-bar-animated" 
                                 role="progressbar" style="width: 0%" id="uploadProgressBar"></div>
                        </div>
                        <p class="text-center mb-0" id="uploadStatusText">Preparing upload...</p>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary" id="startUploadBtn" style="display: none;">
                        <i class="fab fa-instagram me-1"></i>Upload to Instagram
                    </button>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Customer search functionality
        document.addEventListener('DOMContentLoaded', function() {
            const searchInput = document.getElementById('customerSearch');
            if (searchInput) {
                searchInput.addEventListener('input', function() {
                    const searchTerm = this.value.toLowerCase();
                    const tableRows = document.querySelectorAll('tbody tr');
                    
                    tableRows.forEach(row => {
                        const customerName = row.querySelector('h6')?.textContent.toLowerCase() || '';
                        const customerEmail = row.querySelector('p.text-xs')?.textContent.toLowerCase() || '';
                        
                        if (customerName.includes(searchTerm) || customerEmail.includes(searchTerm)) {
                            row.style.display = '';
                        } else {
                            row.style.display = 'none';
                        }
                    });
                });
            }
        });

        let selectedTasks = [];
        let selectedVideos = [];

        // Caption character count
        document.getElementById('uploadCaption').addEventListener('input', function() {
            document.getElementById('uploadCaptionCount').textContent = this.value.length;
        });

        // Open send modal for customer
        function openSendModal(customerId, customerName) {
            document.getElementById('selectedCustomerId').value = customerId;
            document.getElementById('customerNameDisplay').textContent = customerName;
            document.getElementById('uploadCaption').value = '';
            document.getElementById('uploadCaptionCount').textContent = '0';
            document.getElementById('uploadProgressContainer').style.display = 'none';
            selectedTasks = [];
            selectedVideos = [];

            // Load credentials for this customer
            loadCustomerCredentials(customerId);
            
            // Load video tasks for this customer
            loadCustomerVideoTasks(customerId);

            // Show modal
            const modal = new bootstrap.Modal(document.getElementById('sendToInstagramModal'));
            modal.show();
        }

        // Load customer credentials
        function loadCustomerCredentials(customerId) {
            fetch(`{{ url('/instagram/customer-credentials') }}/${customerId}`)
                .then(response => response.json())
                .then(data => {
                    const select = document.getElementById('selectedCredential');
                    select.innerHTML = '<option value="">Choose an account...</option>';
                    
                    if (data.success && data.credentials.length > 0) {
                        data.credentials.forEach(cred => {
                            const option = document.createElement('option');
                            option.value = cred.id;
                            option.textContent = `${cred.credential_name} (${cred.ig_user_id})`;
                            select.appendChild(option);
                        });
                        
                        // Auto-select if only one credential
                        if (data.credentials.length === 1) {
                            select.value = data.credentials[0].id;
                        }
                    } else {
                        select.innerHTML = '<option value="">No credentials available</option>';
                    }
                })
                .catch(error => {
                    console.error('Error loading credentials:', error);
                });
        }

        // Load customer video tasks
        function loadCustomerVideoTasks(customerId) {
            fetch(`{{ url('/instagram/customer-video-tasks') }}/${customerId}`)
                .then(response => response.json())
                .then(data => {
                    const tasksList = document.getElementById('videoTasksList');
                    tasksList.innerHTML = '';
                    
                    if (data.success && data.tasks.length > 0) {
                        data.tasks.forEach(task => {
                            const taskCard = document.createElement('div');
                            taskCard.className = 'col-12 mb-3';
                            
                            // Build video checkboxes HTML
                            let videosHtml = '';
                            task.videos.forEach(video => {
                                videosHtml += `
                                    <div class="form-check mb-2 ps-4">
                                        <input class="form-check-input video-checkbox" type="checkbox" 
                                               value="${video.id}" 
                                               id="video${video.id}"
                                               data-task-id="${task.id}"
                                               data-video-url="${video.video_url}"
                                               data-video-path="${video.video_path}">
                                        <label class="form-check-label" for="video${video.id}">
                                            <small>
                                                📹 ${video.filename}
                                                ${video.duration ? `• ${video.duration}` : ''}
                                                ${video.file_size ? `• ${video.file_size}` : ''}
                                            </small>
                                        </label>
                                    </div>
                                `;
                            });
                            
                            taskCard.innerHTML = `
                                <div class="card">
                                    <div class="card-header pb-2">
                                        <div class="d-flex justify-content-between align-items-center">
                                            <div class="form-check">
                                                <input class="form-check-input task-select-all" type="checkbox" 
                                                       id="selectAll${task.id}"
                                                       data-task-id="${task.id}">
                                                <label class="form-check-label" for="selectAll${task.id}">
                                                    <strong>${task.taskname}</strong>
                                                </label>
                                            </div>
                                            <span class="badge bg-gradient-info">${task.totalvideos} videos</span>
                                        </div>
                                        <small class="text-muted">Created: ${task.created_at}</small>
                                    </div>
                                    <div class="card-body pt-2">
                                        ${videosHtml}
                                    </div>
                                </div>
                            `;
                            tasksList.appendChild(taskCard);
                        });

                        // Add event listeners for select all checkboxes
                        document.querySelectorAll('.task-select-all').forEach(checkbox => {
                            checkbox.addEventListener('change', function() {
                                const taskId = this.getAttribute('data-task-id');
                                const videoCheckboxes = document.querySelectorAll(`.video-checkbox[data-task-id="${taskId}"]`);
                                videoCheckboxes.forEach(vcb => {
                                    vcb.checked = this.checked;
                                });
                                updateSelectedVideos();
                            });
                        });

                        // Add event listeners for individual video checkboxes
                        document.querySelectorAll('.video-checkbox').forEach(checkbox => {
                            checkbox.addEventListener('change', function() {
                                // Update select all checkbox state
                                const taskId = this.getAttribute('data-task-id');
                                const taskCheckboxes = document.querySelectorAll(`.video-checkbox[data-task-id="${taskId}"]`);
                                const selectAllCheckbox = document.querySelector(`.task-select-all[data-task-id="${taskId}"]`);
                                
                                const allChecked = Array.from(taskCheckboxes).every(cb => cb.checked);
                                const someChecked = Array.from(taskCheckboxes).some(cb => cb.checked);
                                
                                selectAllCheckbox.checked = allChecked;
                                selectAllCheckbox.indeterminate = someChecked && !allChecked;
                                
                                updateSelectedVideos();
                            });
                        });
                    } else {
                        tasksList.innerHTML = `
                            <div class="col-12 text-center py-4">
                                <p class="text-muted">No unsent videos found for this customer.</p>
                            </div>
                        `;
                    }
                })
                .catch(error => {
                    console.error('Error loading tasks:', error);
                    document.getElementById('videoTasksList').innerHTML = `
                        <div class="col-12 text-center py-4">
                            <p class="text-danger">Error loading tasks. Please try again.</p>
                        </div>
                    `;
                });
        }

        // Update selected videos
        function updateSelectedVideos() {
            selectedTasks = [];
            selectedVideos = [];
            
            document.querySelectorAll('.video-checkbox:checked').forEach(checkbox => {
                const videoId = checkbox.value;
                const videoUrl = checkbox.getAttribute('data-video-url');
                const videoPath = checkbox.getAttribute('data-video-path');
                
                selectedVideos.push({
                    id: videoId,
                    video_url: videoUrl,
                    video_path: videoPath
                });
            });
            
            const uploadBtn = document.getElementById('startUploadBtn');
            uploadBtn.style.display = selectedVideos.length > 0 ? 'block' : 'none';
        }

        // Start upload
        document.getElementById('startUploadBtn').addEventListener('click', function() {
            const credentialId = document.getElementById('selectedCredential').value;
            const caption = document.getElementById('uploadCaption').value;
            
            if (!credentialId) {
                alert('Please select an Instagram account');
                return;
            }
            
            if (selectedVideos.length === 0) {
                alert('Please select at least one video task');
                return;
            }
            
            // Show progress
            document.getElementById('uploadProgressContainer').style.display = 'block';
            this.disabled = true;
            
            // Upload videos sequentially
            // Start parallel upload
            uploadVideosInParallel(selectedVideos, credentialId, caption);
        });

        // Upload videos in parallel (with batching to avoid overwhelming valid requests)
        async function uploadVideosInParallel(videos, credentialId, caption) {
            const batchSize = 3; // Process 3 videos at a time to be safe
            let completedCount = 0;
            let successCount = 0;
            let failCount = 0;
            const totalVideos = videos.length;

            document.getElementById('uploadProgressBar').style.width = '0%';
            document.getElementById('uploadStatusText').textContent = `Starting upload of ${totalVideos} videos...`;

            // Helper to upload a single video
            const uploadSingleVideo = async (video, index) => {
                try {
                    document.getElementById('uploadStatusText').textContent = `Uploading: ${video.filename}...`;
                    
                    const response = await fetch('{{ url('/instagram/upload') }}', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json',
                            'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]').content
                        },
                        body: JSON.stringify({
                            credential_id: credentialId,
                            video_path: video.video_path,
                            video_url: video.video_url,
                            caption: caption,
                            platform: document.getElementById('selectedPlatform').value
                        })
                    });

                    const data = await response.json();

                    if (data.success) {
                        successCount++;
                        console.log(`Video ${index + 1} uploaded successfully`);
                    } else {
                        throw new Error(data.message || 'Upload failed');
                    }
                } catch (error) {
                    failCount++;
                    console.error(`Error uploading video ${index + 1}:`, error);
                } finally {
                    completedCount++;
                    const progress = (completedCount / totalVideos) * 100;
                    document.getElementById('uploadProgressBar').style.width = `${progress}%`;
                    document.getElementById('uploadStatusText').textContent = 
                        `Processed ${completedCount}/${totalVideos} videos (${successCount} success, ${failCount} failed)`;
                }
            };

            // Process in batches
            for (let i = 0; i < videos.length; i += batchSize) {
                const batch = videos.slice(i, i + batchSize);
                await Promise.all(batch.map((video, batchIndex) => uploadSingleVideo(video, i + batchIndex)));
            }

            // Final completion handling
            document.getElementById('uploadProgressBar').classList.remove('progress-bar-animated');
            
            if (failCount === 0) {
                document.getElementById('uploadProgressBar').classList.add('bg-success');
                document.getElementById('uploadStatusText').textContent = 'All videos submitted successfully!';
                
                setTimeout(() => {
                    alert('All videos submitted to background queue!');
                    location.reload();
                }, 1500);
            } else {
                document.getElementById('uploadProgressBar').classList.add('bg-warning');
                document.getElementById('uploadStatusText').textContent = 
                    `Completed with errors: ${successCount} sent, ${failCount} failed. Check console for details.`;
                document.getElementById('startUploadBtn').disabled = false;
                alert(`Uploads completed but ${failCount} videos failed. Please check the logs.`);
            }
        }
    </script>

    {{-- =======================
        CSS FIXES FOR SIDEBAR OVERLAP
    ======================== --}}
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

        .modal { z-index: 1055 !important; }
        .modal-backdrop { z-index: 1050 !important; }
        .sidenav { z-index: 1040; }
    </style>
</x-app-layout>

<meta name="csrf-token" content="{{ csrf_token() }}">
