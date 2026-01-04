<x-app-layout>

    <main class="main-content position-relative max-height-vh-100 h-100 border-radius-lg">
        <x-app.navbar />
        <div class="container-fluid py-4 px-5">
        <div class="row">
            <div class="col-12">
                <div class="card mb-4">
                    <div class="card-header pb-0">
                        <h6>Upload Video Template (Image)</h6>
                        <p class="text-sm">Templates will be used with customer videos like image templates</p>
                    </div>
                    <div class="card-body px-4 pt-4 pb-2">
                        <form id="uploadVideoForm" enctype="multipart/form-data">
                            @csrf
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="name">Template Name <span class="text-danger">*</span></label>
                                        <input type="text" class="form-control" id="name" name="name" required>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="video_type">Video Type <span class="text-danger">*</span></label>
                                        <select class="form-control" id="video_type" name="video_type" required>
                                            <option value="">Select Type</option>
                                            <option value="portrait">Portrait (1080x1920 - Reels/Shorts)</option>
                                            <option value="landscape">Landscape (1920x1080 - YouTube)</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-12">
                                    <div class="form-group">
                                        <label for="image_file">Template Image <span class="text-danger">*</span></label>
                                        <input type="file" class="form-control" id="image_file" name="image_file" accept="image/jpeg,image/jpg,image/png" required>
                                        <small class="text-muted">Supported formats: JPEG, JPG, PNG. Max size: 10MB. This image will be used as the background/overlay for customer videos.</small>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="overlay_x">Overlay Position X (px)</label>
                                        <input type="number" class="form-control" id="overlay_x" name="overlay_x" value="0">
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="overlay_y">Overlay Position Y (px)</label>
                                        <input type="number" class="form-control" id="overlay_y" name="overlay_y" value="0">
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="description">Description</label>
                                <textarea class="form-control" id="description" name="description" rows="3"></textarea>
                            </div>
                            <button type="submit" class="btn btn-primary" id="submitBtn">Upload Template</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <div class="row mt-4">
            <div class="col-12">
                <div class="card mb-4">
                    <div class="card-header pb-0">
                        <h6>Video Templates</h6>
                    </div>
                    <div class="card-body px-0 pt-0 pb-2">
                        @if($templates->count() > 0)
                        <div class="table-responsive p-0">
                            <table class="table align-items-center mb-0">
                                <thead>
                                    <tr>
                                        <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Template Name</th>
                                        <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Video Type</th>
                                        <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Image Preview</th>
                                        <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Size</th>
                                        <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Uploaded</th>
                                        <th class="text-secondary opacity-7">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    @foreach($templates as $template)
                                    <tr>
                                        <td><p class="text-xs font-weight-bold mb-0">{{ $template->name }}</p></td>
                                        <td><p class="text-xs mb-0"><span class="badge badge-{{ $template->video_type == 'portrait' ? 'info' : 'primary' }}">{{ ucfirst($template->video_type) }}</span></p></td>
                                        <td><img src="{{ asset('img/master_template/' . $template->image_path) }}" alt="Template" style="max-width: 100px; max-height: 60px;"></td>
                                        <td><p class="text-xs mb-0">{{ number_format($template->size / 1024, 2) }} KB</p></td>
                                        <td><p class="text-xs mb-0">{{ $template->created_at->format('d M Y') }}</p></td>
                                        <td>
                                            <a href="{{ asset('img/master_template/' . $template->image_path) }}" target="_blank" class="btn btn-sm btn-info">View</a>
                                            <button class="btn btn-sm btn-danger deleteTemplate" data-id="{{ $template->id }}">Delete</button>
                                        </td>
                                    </tr>
                                    @endforeach
                                </tbody>
                            </table>
                        </div>
                        @else
                        <div class="text-center py-5">
                            <i class="ni ni-cloud-upload-96 text-muted" style="font-size: 48px;"></i>
                            <p class="text-muted mt-3">No image templates uploaded yet. Upload your first template above!</p>
                        </div>
                        @endif

                        {{ $templates->links() }}
                    </div>
                </div>
            </div>
        </div>
        </div>
    </main>

</x-app-layout>

<meta name="csrf-token" content="{{ csrf_token() }}">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    $.ajaxSetup({
        headers: {
            'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
        }
    });

    $('#uploadVideoForm').on('submit', function(e) {
        e.preventDefault();
        
        var formData = new FormData(this);
        var submitBtn = $('#submitBtn');
        
        submitBtn.prop('disabled', true).text('Uploading...');
        
        $.ajax({
            url: '{{ route("upload-video-template") }}',
            method: 'POST',
            data: formData,
            processData: false,
            contentType: false,
            success: function(response) {
                alert('Video template uploaded successfully!');
                location.reload();
            },
            error: function(xhr) {
                var errorMsg = 'Error uploading video template';
                if (xhr.responseJSON && xhr.responseJSON.message) {
                    errorMsg = xhr.responseJSON.message;
                } else if (xhr.responseJSON && xhr.responseJSON.error) {
                    errorMsg = xhr.responseJSON.error;
                }
                alert(errorMsg);
                submitBtn.prop('disabled', false).text('Upload Template');
            }
        });
    });

    $(document).on('click', '.deleteTemplate', function() {
        if (confirm('Are you sure you want to delete this template?')) {
            var templateId = $(this).data('id');
            
            $.ajax({
                url: '{{ url('/delete-video-template') }}/' + templateId,
                method: 'DELETE',
                headers: {
                    'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
                },
                success: function(response) {
                    if (response.success) {
                        alert('Template deleted successfully!');
                        location.reload();
                    } else {
                        alert(response.message);
                    }
                },
                error: function(xhr) {
                    alert('Error deleting template');
                }
            });
        }
    });
</script>
