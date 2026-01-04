<x-app-layout>

    <main class="main-content position-relative max-height-vh-100 h-100 border-radius-lg">
        <x-app.navbar />
        <div class="container-fluid py-4 px-5">
        <div class="row">
            <div class="col-12">
                <div class="card mb-4">
                    <div class="card-header pb-0">
                        <h6>Assign Customer Video to Template</h6>
                    </div>
                    <div class="card-body px-4 pt-4 pb-2">
                        <form id="assignVideoForm" enctype="multipart/form-data">
                            @csrf
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="customer_id">Select Customer <span class="text-danger">*</span></label>
                                        <select class="form-control" id="customer_id" name="customer_id" required>
                                            <option value="">Select Customer</option>
                                            @foreach($customers as $customer)
                                            <option value="{{ $customer->id }}">{{ $customer->name }} ({{ $customer->mobile }})</option>
                                            @endforeach
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="video_template_id">Select Video Template <span class="text-danger">*</span></label>
                                        <select class="form-control" id="video_template_id" name="video_template_id" required>
                                            <option value="">Select Template</option>
                                            @foreach($templates as $template)
                                            <option value="{{ $template->id }}" data-type="{{ $template->video_type }}">{{ $template->video_name }} ({{ ucfirst($template->video_type) }})</option>
                                            @endforeach
                                        </select>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-12">
                                    <div class="form-group">
                                        <label for="customer_video">Customer Video <span class="text-danger">*</span></label>
                                        <input type="file" class="form-control" id="customer_video" name="customer_video" accept="video/mp4,video/mov,video/avi" required>
                                        <small class="text-muted">Upload customer's video that will be overlaid on the template. Max size: 100MB</small>
                                    </div>
                                </div>
                            </div>
                            <div class="alert alert-info">
                                <strong>Note:</strong> Make sure the customer video matches the template type:
                                <ul class="mb-0 mt-2">
                                    <li><strong>Portrait templates:</strong> Use videos in 9:16 ratio (e.g., 1080x1920)</li>
                                    <li><strong>Landscape templates:</strong> Use videos in 16:9 ratio (e.g., 1920x1080)</li>
                                </ul>
                            </div>
                            <button type="submit" class="btn btn-primary" id="submitBtn">Assign Video</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <div class="row mt-4">
            <div class="col-12">
                <div class="card mb-4">
                    <div class="card-header pb-0">
                        <h6>Assigned Customer Videos</h6>
                    </div>
                    <div class="card-body px-0 pt-0 pb-2">
                        @if($assignedVideos->count() > 0)
                        <div class="table-responsive p-0">
                            <table class="table align-items-center mb-0">
                                <thead>
                                    <tr>
                                        <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Customer</th>
                                        <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Template</th>
                                        <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Video Type</th>
                                        <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Duration</th>
                                        <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Size</th>
                                        <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Assigned</th>
                                        <th class="text-secondary opacity-7">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    @foreach($assignedVideos as $video)
                                    <tr>
                                        <td><p class="text-xs font-weight-bold mb-0">{{ $video->customer->name }}</p></td>
                                        <td><p class="text-xs mb-0">{{ $video->videoTemplate->video_name }}</p></td>
                                        <td><p class="text-xs mb-0"><span class="badge badge-{{ $video->videoTemplate->video_type == 'portrait' ? 'info' : 'primary' }}">{{ ucfirst($video->videoTemplate->video_type) }}</span></p></td>
                                        <td><p class="text-xs mb-0">{{ round($video->duration, 2) }}s</p></td>
                                        <td><p class="text-xs mb-0">{{ number_format($video->size / 1024 / 1024, 2) }} MB</p></td>
                                        <td><p class="text-xs mb-0">{{ $video->created_at->format('d M Y') }}</p></td>
                                        <td>
                                            <a href="{{ asset('videos/user_template/' . $video->video_path) }}" target="_blank" class="btn btn-sm btn-info">Preview</a>
                                            <button class="btn btn-sm btn-danger deleteVideo" data-id="{{ $video->id }}">Delete</button>
                                        </td>
                                    </tr>
                                    @endforeach
                                </tbody>
                            </table>
                        </div>
                        @else
                        <div class="text-center py-5">
                            <i class="ni ni-folder-17 text-muted" style="font-size: 48px;"></i>
                            <p class="text-muted mt-3">No customer videos assigned yet. Upload customer videos above!</p>
                        </div>
                        @endif

                        {{ $assignedVideos->links() }}
                    </div>
                </div>
            </div>
        </div>
        </div>
    </main>

</x-app-layout>

<script>
<script>
    $('#assignVideoForm').on('submit', function(e) {
        e.preventDefault();
        
        var formData = new FormData(this);
        var submitBtn = $('#submitBtn');
        
        submitBtn.prop('disabled', true).text('Uploading...');
        
        $.ajax({
            url: '{{ url('/assign-video-to-customer') }}',
            method: 'POST',
            data: formData,
            processData: false,
            contentType: false,
            success: function(response) {
                if (response.success) {
                    alert('Customer video assigned successfully!');
                    location.reload();
                } else {
                    alert(response.message);
                    submitBtn.prop('disabled', false).text('Assign Video');
                }
            },
            error: function(xhr) {
                alert('Error assigning video');
                submitBtn.prop('disabled', false).text('Assign Video');
            }
        });
    });

    $(document).on('click', '.deleteVideo', function() {
        if (confirm('Are you sure you want to delete this video assignment?')) {
            var videoId = $(this).data('id');
            
            $.ajax({
                url: '{{ url('/delete-customer-video') }}/' + videoId,
                method: 'DELETE',
                headers: {
                    'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
                },
                success: function(response) {
                    if (response.success) {
                        alert('Video assignment deleted successfully!');
                        location.reload();
                    } else {
                        alert(response.message);
                    }
                },
                error: function(xhr) {
                    alert('Error deleting video');
                }
            });
        }
    });

    // Highlight template type when selected
    $('#video_template_id').on('change', function() {
        var selectedOption = $(this).find('option:selected');
        var videoType = selectedOption.data('type');
        
        if (videoType) {
            var typeText = videoType === 'portrait' ? 'Portrait (9:16 - Reels/Shorts)' : 'Landscape (16:9 - YouTube)';
            $('.alert-info').show().html('<strong>Selected Template Type:</strong> ' + typeText + '<br><small>Please upload a customer video matching this ratio.</small>');
        }
    });
</script>
