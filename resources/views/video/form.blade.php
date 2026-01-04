<x-app-layout>

    <main class="main-content position-relative max-height-vh-100 h-100 border-radius-lg ">
        <x-app.navbar />
        <div class="container-fluid py-4 px-5">
  <div class="card card-background card-background-after-none align-items-start mt-4 mb-5">
                        <div class="full-background" style="background-image: url('{{ asset('assets/img/header-blue-purple.jpg') }}')"></div>
                        <div class="card-body text-start p-4 w-100 d-flex justify-content-between align-items-center">
                            <h3 class="text-white mb-2">Create Video Task 🔥</h3>
                            <div class="d-flex align-items-center gap-2">
                                <span class="badge bg-secondary" id="gpuStatus">
                                    <i class="fas fa-microchip me-1"></i>
                                    GPU: <span id="gpuStatusText">Loading...</span>
                                </span>
                                <button type="button" class="btn btn-sm btn-outline-light mb-0" id="toggleGpuBtn" onclick="toggleGPU()">
                                    <i class="fas fa-power-off me-1"></i>
                                </button>
                            </div>
                        </div>
                        <div class="row justify-content-center">
                            <div class="">
                                @if (session('success'))
                                <div class="alert alert-success" role="alert" id="alert">
                                    {{ session('success') }}
                                </div>
                                @endif
                                @if (session('error'))
                                <div class="alert alert-danger" role="alert" id="alert">
                                    {{ session('error') }}
                                </div>
                                @endif
                            </div>
                        </div>
                    </div>
            <div class="card border shadow-sm mb-4">
                <div class="card-body">
                    <h4 class="card-title text-center">Add Task To Generate Videos</h4>

                    <div class="row">
                        <div class="col-md-6">
                            <form id="tempForm">
                                <div class="mb-3">
                                    <label for="dropdown" class="form-label">Choose Video Template (Image)</label>
                                    <select id="dropdown" class="form-select">
                                        <option value="">Select</option>
                                        @foreach ($templates as $template)
                                        <option value="{{ $template->id }}">{{ $template->name }}</option>
                                        @endforeach
                                    </select>
                                </div>

                                <div class="mb-3">
                                    <label for="videoUpload" class="form-label">Upload Background Video</label>
                                    <input type="file" id="videoUpload" class="form-control" accept="video/*">
                                    <small class="text-muted">This video will be used as the background for all generated videos in this task</small>
                                </div>

                                <div class="mb-3">
                                    <label for="animationEffect" class="form-label">Animation Effect</label>
                                    <select id="animationEffect" class="form-select">
                                        <option value="wipe-in">Wipe In (Left to Right)</option>
                                        <option value="fade-in">Fade In (Gradual Opacity)</option>
                                        <option value="slide-in">Slide In (From Left)</option>
                                        <option value="zoom-in">Zoom In (Scale Up)</option>
                                        <option value="bounce-in">Bounce In (Elastic Bounce)</option>
                                        <option value="flip-in">Flip In (3D Flip)</option>
                                        <option value="blur-in">Blur In (Sharp Focus)</option>
                                        <option value="spiral-in">Spiral In (Spin & Zoom)</option>
                                        <option value="corner-wipe">Corner Wipe (Diagonal)</option>
                                        <option value="curtain">Curtain (Open Center)</option>
                                        <option value="none">None (Instant Overlay)</option>
                                    </select>
                                    <small class="text-muted">Choose how the template will appear over the background video</small>
                                </div>
                                <button type="button" id="addButton" class="btn btn-primary mt-3">Add</button>
                        </div>
                                <div class="col-md-6">
                                    <div id="previewContainer" style="position: relative; width: 50%; height: 250px; border: 1px solid #ccc;">
                                        <video id="uploadPreview" style="position: absolute; width: 100%; height: 100%; display: none;" controls></video>
                                        <img id="templatePreview" class="image-preview" style="position: absolute; width: 100%; height: 100%; object-fit: contain; display: none;">
                                    </div>
                                </div>
                                
                            </form>
                        </div>
                    </div>

                    <div class="table-container mt-4">
                        <table id="tempTable" class="table table-striped table-bordered">
                            <thead class="table-dark">
                                <tr>
                                    <th>Template Name</th>
                                    <th>Background Video</th>
                                    <th>Animation</th>
                                    <th>Total Videos</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <!-- Dynamic rows will be appended here -->
                            </tbody>
                        </table>
                    </div>

                    <div class="text-center">
                        <button type="button" id="submitButton" class="btn btn-success mt-3">Submit</button>
                    </div>
                </div>
            </div>

            <x-app.footer />
        </div>
    </main>

</x-app-layout>

<meta name="csrf-token" content="{{ csrf_token() }}">

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<script>
    $(document).ready(function() {
        $.ajaxSetup({
            headers: {
                'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
            }
        });

        // Handle video preview for uploaded video
        $('#videoUpload').on('change', function(event) {
            const file = event.target.files[0];
            if (file && file.type.startsWith('video/')) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    $('#uploadPreview').attr('src', e.target.result).show();
                    $('#templatePreview').hide();
                };
                reader.readAsDataURL(file);
            }
        });

        // Handle dropdown change to show template preview
        $('#dropdown').on('change', function() {
            const selectedOption = $(this).find('option:selected');
            const templateId = selectedOption.val();

            if (templateId) {
                $.ajax({
                    url: `{{ url('/get-video-template-image') }}/${templateId}`,
                    method: 'GET',
                    success: function(response) {
                        $('#templatePreview').attr('src', response.imagePath).show();
                        if ($('#uploadPreview').attr('src')) {
                            $('#uploadPreview').show();
                        }
                    },
                    error: function(xhr, status, error) {
                        console.error('Error fetching template image:', error);
                    }
                });
            } else {
                $('#templatePreview').hide();
            }
        });

        let tempData = [];

        $('#addButton').on('click', function() {
            const dropdown = $('#dropdown');
            const videoUpload = $('#videoUpload')[0];
            const animationEffect = $('#animationEffect');
            const selectedOption = dropdown.find('option:selected');
            const templateId = selectedOption.val();
            const templateName = selectedOption.text();
            const selectedAnimation = animationEffect.val();

            if (!templateId || !videoUpload.files[0]) {
                alert('Please select a template and upload a background video.');
                return;
            }

            const videoFile = videoUpload.files[0];

            // Create FormData to send to tempdata endpoint
            const formData = new FormData();
            formData.append('_token', $('meta[name="csrf-token"]').attr('content'));
            formData.append('option', templateId);
            formData.append('video', videoFile);
            formData.append('animation_effect', selectedAnimation);

            // Disable button while processing
            const addBtn = $(this);
            addBtn.prop('disabled', true).text('Adding...');

            // Save to Tempstore via /tempdata endpoint
            $.ajax({
                url: '{{ route('tempdata') }}',
                method: 'POST',
                data: formData,
                processData: false,
                contentType: false,
                success: function(response) {
                    if (response.success) {
                        tempData.push({
                            id: response.id,
                            templateId: templateId,
                            templateName: templateName,
                            videoName: videoFile.name,
                            totalVideos: response.total_image || 0,
                            animationEffect: selectedAnimation
                        });
                        
                        updateTable();
                        dropdown.val('');
                        videoUpload.value = '';
                        animationEffect.val('wipe-in'); // Reset to default
                        $('#uploadPreview').attr('src', '').hide();
                        $('#templatePreview').attr('src', '').hide();
                        addBtn.prop('disabled', false).text('Add');
                    } else {
                        alert(response.error || 'Error adding video');
                        addBtn.prop('disabled', false).text('Add');
                    }
                },
                error: function(xhr) {
                    const errorMsg = xhr.responseJSON?.error || 'Error adding video';
                    alert('Error: ' + errorMsg);
                    addBtn.prop('disabled', false).text('Add');
                }
            });
        });

        function updateTable() {
            const tableBody = $('#tempTable tbody');
            tableBody.empty();

            tempData.forEach((item, index) => {
                // Format animation name for display
                const animationDisplay = item.animationEffect ? item.animationEffect.replace('-', ' ').replace(/\b\w/g, l => l.toUpperCase()) : 'Wipe In';
                
                const row = `
                    <tr>
                        <td>${item.templateName}</td>
                        <td>${item.videoName}</td>
                        <td><span class="badge bg-info">${animationDisplay}</span></td>
                        <td>${item.totalVideos}</td>
                        <td><button class="btn btn-danger btn-sm deleteRow" data-index="${index}" data-id="${item.id}">Delete</button></td>
                    </tr>
                `;
                tableBody.append(row);
            });
        }

        $(document).on('click', '.deleteRow', function() {
            const index = $(this).data('index');
            const id = $(this).data('id');
            
            // Delete from Tempstore via /tempdata/delete endpoint
            $.ajax({
                url: '{{ route('tempdata.delete') }}',
                method: 'POST',
                data: {
                    _token: $('meta[name="csrf-token"]').attr('content'),
                    id: id
                },
                success: function(response) {
                    tempData.splice(index, 1);
                    updateTable();
                },
                error: function(xhr) {
                    alert('Error deleting item');
                }
            });
        });

        $('#submitButton').on('click', function() {
            if (tempData.length === 0) {
                alert('Please add at least one template and background video.');
                return;
            }

            const submitBtn = $(this);
            submitBtn.prop('disabled', true).text('Processing...');

            // Simply call process-video-temp-data - data is already in Tempstore
            $.ajax({
                url: '{{ route('process-video-temp-data') }}',
                method: 'POST',
                data: {
                    _token: $('meta[name="csrf-token"]').attr('content')
                },
                success: function(response) {
                    submitBtn.prop('disabled', false).text('Submit');
                    if (response.success) {
                        alert('Video task created successfully! Task name: ' + response.task_name);
                        tempData = [];
                        updateTable();
                        // Redirect to task list
                        window.location.href = '{{ url('/generate-videos') }}';
                    } else {
                        alert(response.message || 'Error creating task');
                    }
                },
                error: function(xhr, status, error) {
                    console.error('AJAX Error:', {xhr, status, error});
                    console.error('Response Text:', xhr.responseText);
                    submitBtn.prop('disabled', false).text('Submit');
                    const errorMsg = xhr.responseJSON?.message || xhr.responseText || 'Error creating video task';
                    alert('Error: ' + errorMsg);
                }
            });
        });


        // Load GPU status on page load
        loadGPUStatus();
    });

    // GPU Management Functions
    function loadGPUStatus() {
        $.ajax({
            url: '{{ url('/api/gpu-status') }}',
            method: 'GET',
            success: function(data) {
                updateGPUUI(data);
            },
            error: function() {
                updateGPUUI({ success: false });
            }
        });
    }

    function toggleGPU() {
        const btn = $('#toggleGpuBtn');
        const icon = btn.find('i');
        
        btn.prop('disabled', true);
        icon.removeClass('fa-power-off').addClass('fa-spinner fa-spin');
        
        $.ajax({
            url: '{{ url('/api/toggle-gpu') }}',
            method: 'POST',
            data: {
                _token: $('meta[name="csrf-token"]').attr('content')
            },
            success: function(data) {
                updateGPUUI(data);
                alert(data.message || (data.success ? 'GPU setting updated' : 'Failed to update'));
            },
            error: function() {
                alert('Error toggling GPU');
            },
            complete: function() {
                btn.prop('disabled', false);
                icon.removeClass('fa-spinner fa-spin').addClass('fa-power-off');
            }
        });
    }

    function updateGPUUI(data) {
        const text = $('#gpuStatusText');
        const badge = $('#gpuStatus');
        
        if (data.success) {
            if (data.enabled && data.available) {
                text.text(`Enabled (${data.encoder || 'NVENC'})`);
                badge.removeClass('bg-secondary bg-warning bg-danger').addClass('bg-success');
                badge.attr('title', 'GPU Acceleration is Active');
            } else if (data.enabled && !data.available) {
                text.text('Enabled (No GPU Detected)');
                badge.removeClass('bg-secondary bg-success bg-danger').addClass('bg-warning');
                badge.attr('title', data.message || 'GPU enabled but not detected');
            } else {
                text.text('Disabled');
                badge.removeClass('bg-success bg-warning bg-danger').addClass('bg-secondary');
                badge.attr('title', 'GPU Acceleration is OFF');
            }
        } else {
            text.text('Error');
            badge.removeClass('bg-success bg-warning bg-secondary').addClass('bg-danger');
        }
    }
</script>
