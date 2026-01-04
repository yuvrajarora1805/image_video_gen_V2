<x-app-layout>
    <main class="main-content position-relative max-height-vh-100 h-100 border-radius-lg">
        <div class="container-fluid py-4">

            <!-- ================= HEADER ================= -->
            <div class="row mb-4">
                <div class="col-12">
                    <div class="card shadow-sm">
                        <div class="card-body d-flex justify-content-between align-items-center flex-wrap gap-3">
                            <div>
                                <h4 class="fw-semibold mb-1">Master Instagram Uploader</h4>
                                <p class="text-sm text-muted mb-0">
                                    Bulk upload videos to Instagram & Facebook for all customers
                                </p>
                            </div>

                            <button class="btn btn-primary px-4"
                                    id="reviewUploadBtn"
                                    onclick="reviewUpload()"
                                    disabled>
                                <i class="fas fa-eye me-2"></i>
                                Review & Upload
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- ================= TOOLBAR ================= -->
            <div class="row mb-3 align-items-center">
                <div class="col-lg-6 col-md-12 mb-2">
                    <div class="input-group shadow-sm">
                        <span class="input-group-text bg-white">
                            <i class="fas fa-search text-muted"></i>
                        </span>
                        <input type="text"
                               class="form-control"
                               id="customerSearch"
                               placeholder="Search customers by name or email">
                    </div>
                </div>

                <div class="col-lg-6 col-md-12 d-flex justify-content-lg-end gap-2 flex-wrap">
                    <div class="form-check form-switch mt-1">
                        <input class="form-check-input" type="checkbox" id="filterCredentials" onchange="filterCustomers()">
                        <label class="form-check-label text-sm">Only with credentials</label>
                    </div>

                    <button class="btn btn-outline-primary btn-sm" onclick="selectAll()">
                        <i class="fas fa-check-square me-1"></i> Select All
                    </button>

                    <button class="btn btn-outline-secondary btn-sm" onclick="deselectAll()">
                        <i class="fas fa-square me-1"></i> Clear
                    </button>
                </div>
            </div>

            <!-- ================= CUSTOMER LIST ================= -->
            <div id="customersList" class="row g-3">
                <div class="col-12 text-center py-5">
                    <div class="spinner-border text-primary"></div>
                    <p class="text-sm mt-2 text-muted">Loading customers...</p>
                </div>
            </div>

        </div>
    </main>

    <!-- ================= REVIEW MODAL ================= -->
    <div class="modal fade" id="reviewModal" tabindex="-1">
        <div class="modal-dialog modal-xl modal-dialog-scrollable">
            <div class="modal-content">
                <div class="modal-header">
                    <div>
                        <h5 class="modal-title fw-semibold">
                            <i class="fas fa-eye me-2"></i>Review Upload
                        </h5>
                        <p class="text-sm text-muted mb-0">
                            Verify videos before starting upload
                        </p>
                    </div>
                    <button class="btn-close" data-bs-dismiss="modal"></button>
                </div>

                <div class="modal-body">
                    <div class="alert alert-info text-sm">
                        <strong>Platform:</strong> <span id="reviewPlatform"></span><br>
                        <strong>Total Videos:</strong> <span id="reviewTotalVideos"></span>
                    </div>

                    <div id="reviewVideosList"></div>
                </div>

                <div class="modal-footer">
                    <button class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button class="btn btn-primary" onclick="confirmUpload()">
                        <i class="fab fa-instagram me-1"></i> Start Upload
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- ================= CAPTION MODAL ================= -->
    <div class="modal fade" id="captionModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <div>
                        <h5 class="modal-title fw-semibold">
                            <i class="fas fa-comment-dots me-2"></i>Set Default Caption
                        </h5>
                        <p class="text-sm text-muted mb-0" id="captionCustomerName"></p>
                    </div>
                    <button class="btn-close" data-bs-dismiss="modal"></button>
                </div>

                <div class="modal-body">
                    <label class="form-label text-sm">Caption (optional)</label>
                    <textarea class="form-control" 
                              id="captionInput" 
                              rows="4" 
                              placeholder="Enter default caption for this customer's videos..."></textarea>
                    <small class="text-muted">This caption will be used for all videos uploaded for this customer.</small>
                </div>

                <div class="modal-footer">
                    <button class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button class="btn btn-primary" onclick="saveCaption()">
                        <i class="fas fa-save me-1"></i> Save Caption
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- ================= UPLOAD PROGRESS MODAL ================= -->
    <div class="modal fade" id="uploadProgressModal" tabindex="-1"
         data-bs-backdrop="static" data-bs-keyboard="false">
        <div class="modal-dialog modal-sm modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-body text-center">
                    <h6 class="fw-semibold mb-3">Uploading Videos</h6>

                    <div class="progress mb-3" style="height:8px">
                        <div class="progress-bar progress-bar-striped progress-bar-animated"
                             id="uploadProgressBar"
                             style="width:0%">
                        </div>
                    </div>

                    <p class="text-sm text-muted mb-0" id="uploadStatusText">
                        Preparing upload…
                    </p>
                </div>
            </div>
        </div>
    </div>

    <!-- ================= SCRIPTS ================= -->
    <script>
        let allCustomersData = [];
        let selectedCustomers = new Set();
        let selectedVideosForReview = [];
        let customerPlatforms = {};
        let customerCaptions = {};

        // Load saved settings from localStorage
        function loadSavedSettings() {
            const savedPlatforms = localStorage.getItem('masterUploader_platforms');
            const savedCaptions = localStorage.getItem('masterUploader_captions');
            
            if (savedPlatforms) {
                try {
                    customerPlatforms = JSON.parse(savedPlatforms);
                } catch (e) {
                    console.error('Error loading saved platforms:', e);
                }
            }
            
            if (savedCaptions) {
                try {
                    customerCaptions = JSON.parse(savedCaptions);
                } catch (e) {
                    console.error('Error loading saved captions:', e);
                }
            }
        }

        // Save settings to localStorage
        function saveSettings() {
            localStorage.setItem('masterUploader_platforms', JSON.stringify(customerPlatforms));
            localStorage.setItem('masterUploader_captions', JSON.stringify(customerCaptions));
        }

        document.addEventListener('DOMContentLoaded', () => {
            loadSavedSettings();
            loadAllPendingVideos();
            document.getElementById('customerSearch').addEventListener('input', filterCustomers);
        });

        function loadAllPendingVideos() {
            fetch('{{ route("instagram.all-pending-videos") }}')
                .then(r => r.json())
                .then(data => {
                    if (data.success) {
                        allCustomersData = data.customers;
                        renderCustomers(data.customers);
                    } else {
                        document.getElementById('customersList').innerHTML =
                            `<div class="col-12 text-center text-muted">No pending videos</div>`;
                    }
                })
                .catch(err => {
                    console.error('Error loading customers:', err);
                    document.getElementById('customersList').innerHTML =
                        `<div class="col-12 text-center text-danger">Error loading customers</div>`;
                });
        }

        function renderCustomers(customers) {
            const list = document.getElementById('customersList');
            list.innerHTML = '';

            if (customers.length === 0) {
                list.innerHTML = `<div class="col-12 text-center py-5">
                    <i class="fas fa-check-circle fa-3x text-success mb-3"></i>
                    <p class="text-muted">No pending videos to upload!</p>
                </div>`;
                return;
            }

            customers.forEach(c => {
                if (!customerPlatforms[c.id]) customerPlatforms[c.id] = 'instagram';

                const col = document.createElement('div');
                col.className = 'col-xl-4 col-lg-6';
                col.innerHTML = `
                    <div class="card customer-card shadow-sm h-100"
                         data-customer-name="${c.name.toLowerCase()}"
                         data-customer-email="${(c.email||'').toLowerCase()}"
                         data-has-credentials="${c.credentials.length>0}">
                        <div class="card-body d-flex flex-column gap-3">

                            <div class="d-flex justify-content-between">
                                <div class="d-flex gap-2">
                                    <input class="form-check-input customer-checkbox"
                                           type="checkbox"
                                           value="${c.id}"
                                           id="customer${c.id}"
                                           onchange="toggleCustomer(${c.id})">
                                    <div>
                                        <h6 class="mb-0 fw-semibold">${c.name}</h6>
                                        <p class="text-xs text-muted mb-0">${c.email || 'No email'}</p>
                                    </div>
                                </div>

                                <div class="text-end">
                                    <span class="badge bg-gradient-info">${c.pending_count} videos</span>
                                    <span class="badge ${c.credentials.length ? 'bg-gradient-success':'bg-gradient-warning'} ms-1">
                                        ${c.credentials.length ? c.credentials.length+' cred' : 'No cred'}
                                    </span>
                                </div>
                            </div>

                            <div class="btn-group btn-group-sm w-100" role="group">
                                <input type="radio" class="btn-check" 
                                       name="p${c.id}" 
                                       id="p${c.id}ig"
                                       ${customerPlatforms[c.id] === 'instagram' ? 'checked' : ''}
                                       onchange="updatePlatform(${c.id}, 'instagram')">
                                <label class="btn btn-outline-danger w-100" for="p${c.id}ig">
                                    <i class="fab fa-instagram"></i> IG
                                </label>

                                <input type="radio" class="btn-check" 
                                       name="p${c.id}"
                                       id="p${c.id}fb"
                                       ${customerPlatforms[c.id] === 'facebook' ? 'checked' : ''}
                                       onchange="updatePlatform(${c.id}, 'facebook')">
                                <label class="btn btn-outline-primary w-100" for="p${c.id}fb">
                                    <i class="fab fa-facebook"></i> FB
                                </label>

                                <input type="radio" class="btn-check" 
                                       name="p${c.id}"
                                       id="p${c.id}both"
                                       ${customerPlatforms[c.id] === 'both' ? 'checked' : ''}
                                       onchange="updatePlatform(${c.id}, 'both')">
                                <label class="btn btn-outline-info w-100" for="p${c.id}both">
                                    <i class="fab fa-instagram"></i><i class="fab fa-facebook"></i> Both
                                </label>
                            </div>

                            <button class="btn btn-outline-secondary btn-sm w-100" onclick="setCaption(${c.id}, '${c.name}')">
                                <i class="fas fa-comment-dots me-1"></i>
                                ${customerCaptions[c.id] ? 'Edit Caption' : 'Set Caption'}
                            </button>

                            ${c.credentials.length===0 ? `
                            <div class="alert alert-warning py-1 mb-0 text-xs">
                                ⚠ No credentials. <a href="{{ route('instagram.credentials') }}">Add</a>
                            </div>`:''}

                        </div>
                    </div>`;
                list.appendChild(col);
            });
        }

        function updatePlatform(customerId, platform) {
            customerPlatforms[customerId] = platform;
            saveSettings();
        }

        function toggleCustomer(id){
            selectedCustomers.has(id) ? selectedCustomers.delete(id) : selectedCustomers.add(id);
            updateReviewButton();
        }

        function updateReviewButton() {
            const btn = document.getElementById('reviewUploadBtn');
            btn.disabled = selectedCustomers.size === 0;
            btn.innerHTML = selectedCustomers.size > 0 
                ? `<i class="fas fa-eye me-2"></i>Review & Upload (${selectedCustomers.size})`
                : `<i class="fas fa-eye me-2"></i>Review & Upload`;
        }

        function selectAll(){
            document.querySelectorAll('.customer-card').forEach(card => {
                if (card.parentElement.style.display !== 'none') {
                    const checkbox = card.querySelector('.customer-checkbox');
                    checkbox.checked = true;
                    selectedCustomers.add(+checkbox.value);
                }
            });
            updateReviewButton();
        }

        function deselectAll(){
            document.querySelectorAll('.customer-checkbox').forEach(cb => cb.checked = false);
            selectedCustomers.clear();
            updateReviewButton();
        }

        let currentCaptionCustomerId = null;

        function setCaption(customerId, customerName) {
            currentCaptionCustomerId = customerId;
            document.getElementById('captionCustomerName').textContent = `For: ${customerName}`;
            document.getElementById('captionInput').value = customerCaptions[customerId] || '';
            
            const modal = new bootstrap.Modal(document.getElementById('captionModal'));
            modal.show();
        }

        function saveCaption() {
            const caption = document.getElementById('captionInput').value.trim();
            customerCaptions[currentCaptionCustomerId] = caption;
            saveSettings();
            
            bootstrap.Modal.getInstance(document.getElementById('captionModal')).hide();
            
            // Re-render to update button text
            renderCustomers(allCustomersData);
            
            // Restore selections
            selectedCustomers.forEach(id => {
                const checkbox = document.getElementById(`customer${id}`);
                if (checkbox) checkbox.checked = true;
            });
        }

        function filterCustomers(){
            const q = document.getElementById('customerSearch').value.toLowerCase();
            const onlyCred = document.getElementById('filterCredentials').checked;
            
            document.querySelectorAll('.customer-card').forEach(c => {
                const match = c.dataset.customerName.includes(q) || c.dataset.customerEmail.includes(q);
                const cred = !onlyCred || c.dataset.hasCredentials === 'true';
                c.parentElement.style.display = (match && cred) ? '' : 'none';
            });
        }

        function reviewUpload() {
            selectedVideosForReview = [];

            allCustomersData.forEach(customer => {
                if (selectedCustomers.has(customer.id)) {
                    if (customer.credentials.length === 0) {
                        alert(`Customer "${customer.name}" has no Instagram credentials. Please add credentials first.`);
                        return;
                    }
                    const customerPlatform = customerPlatforms[customer.id] || 'instagram';
                    customer.videos.forEach(video => {
                        selectedVideosForReview.push({
                            ...video,
                            customer_id: customer.id,
                            customer_name: customer.name,
                            credential_id: customer.credentials[0].id,
                            platform: customerPlatform
                        });
                    });
                }
            });

            if (selectedVideosForReview.length === 0) {
                alert('No videos to upload from selected customers.');
                return;
            }

            displayReviewModal(selectedVideosForReview);
        }

        function displayReviewModal(videos) {
            const platformCounts = videos.reduce((acc, v) => {
                acc[v.platform] = (acc[v.platform] || 0) + 1;
                return acc;
            }, {});
            
            const platformText = Object.keys(platformCounts).map(p => {
                const label = p === 'both' ? 'Both' : p === 'facebook' ? 'Facebook' : 'Instagram';
                return `${label} (${platformCounts[p]})`;
            }).join(', ');
            
            document.getElementById('reviewPlatform').textContent = platformText;
            document.getElementById('reviewTotalVideos').textContent = videos.length;

            const container = document.getElementById('reviewVideosList');
            container.innerHTML = '';

            const groupedByCustomer = {};
            videos.forEach(video => {
                if (!groupedByCustomer[video.customer_name]) {
                    groupedByCustomer[video.customer_name] = [];
                }
                groupedByCustomer[video.customer_name].push(video);
            });

            Object.keys(groupedByCustomer).forEach(customerName => {
                const customerVideos = groupedByCustomer[customerName];
                const customerCard = document.createElement('div');
                customerCard.className = 'card mb-3';
                
                let videosHtml = '';
                customerVideos.forEach(video => {
                    videosHtml += `
                        <div class="form-check mb-2">
                            <input class="form-check-input review-video-checkbox" 
                                   type="checkbox" 
                                   value="${video.id}" 
                                   id="reviewVideo${video.id}"
                                   checked>
                            <label class="form-check-label" for="reviewVideo${video.id}">
                                <small>📹 ${video.filename}</small>
                            </label>
                        </div>
                    `;
                });

                customerCard.innerHTML = `
                    <div class="card-header pb-2">
                        <h6 class="mb-0">${customerName}</h6>
                        <small class="text-muted">${customerVideos.length} video(s)</small>
                    </div>
                    <div class="card-body pt-2">
                        ${videosHtml}
                    </div>
                `;
                container.appendChild(customerCard);
            });

            const modal = new bootstrap.Modal(document.getElementById('reviewModal'));
            modal.show();
        }

        function confirmUpload() {
            const checkedVideoIds = new Set();
            document.querySelectorAll('.review-video-checkbox:checked').forEach(cb => {
                checkedVideoIds.add(parseInt(cb.value));
            });

            const videosToUpload = selectedVideosForReview.filter(v => checkedVideoIds.has(v.id));

            if (videosToUpload.length === 0) {
                alert('No videos selected for upload.');
                return;
            }

            bootstrap.Modal.getInstance(document.getElementById('reviewModal')).hide();

            const progressModal = new bootstrap.Modal(document.getElementById('uploadProgressModal'));
            progressModal.show();

            uploadVideosSequentially(videosToUpload);
        }

        async function uploadVideosSequentially(videos) {
            let completed = 0;
            let success = 0;
            let failed = 0;

            for (const video of videos) {
                try {
                    document.getElementById('uploadStatusText').textContent = 
                        `Uploading: ${video.filename} (${completed + 1}/${videos.length})`;

                    const response = await fetch('{{ route("instagram.upload") }}', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json',
                            'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]').content
                        },
                        body: JSON.stringify({
                            credential_id: video.credential_id,
                            video_path: video.video_path,
                            video_url: video.video_url,
                            caption: customerCaptions[video.customer_id] || '',
                            platform: video.platform
                        })
                    });

                    const data = await response.json();
                    if (data.success) {
                        success++;
                    } else {
                        failed++;
                    }
                } catch (error) {
                    console.error('Upload error:', error);
                    failed++;
                }

                completed++;
                const progress = (completed / videos.length) * 100;
                document.getElementById('uploadProgressBar').style.width = `${progress}%`;
            }

            document.getElementById('uploadProgressBar').classList.remove('progress-bar-animated');
            document.getElementById('uploadProgressBar').classList.add(failed === 0 ? 'bg-success' : 'bg-warning');
            document.getElementById('uploadStatusText').textContent = 
                `Completed: ${success} successful, ${failed} failed`;

            setTimeout(() => {
                bootstrap.Modal.getInstance(document.getElementById('uploadProgressModal')).hide();
                alert(`Upload completed!\n${success} videos uploaded successfully\n${failed} videos failed`);
                location.reload();
            }, 2000);
        }
    </script>

    <!-- ================= STYLES ================= -->
    <style>
        .customer-card {
            transition: transform .15s ease, box-shadow .15s ease;
        }
        .customer-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 .75rem 1.5rem rgba(0,0,0,.08);
        }

        .badge {
            font-weight: 500;
        }

        .btn-group .btn {
            font-size: .75rem;
        }

        @media (min-width:1200px){
            .main-content { margin-left:17.125rem }
        }
        @media (max-width:1199px){
            .main-content { margin-left:0 }
        }
    </style>
</x-app-layout>

<meta name="csrf-token" content="{{ csrf_token() }}">
