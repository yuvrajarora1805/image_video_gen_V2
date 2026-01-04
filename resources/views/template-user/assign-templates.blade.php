<x-app-layout>

    <main class="main-content position-relative max-height-vh-100 h-100 border-radius-lg ">
        <x-app.navbar />
        <div class="container-fluid py-4 px-5">
            <div class="row">
                <div class="col-12">
                    <div class="card card-background card-background-after-none align-items-start mt-4 mb-5">
                        <div class="full-background" style="background-image: url('{{ asset('assets/img/header-blue-purple.jpg') }}')"></div>
                        <div class="card-body text-start p-4 w-100">
                            <h3 class="text-white mb-2">Assign Templates 🔥</h3>

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
                </div>
            </div>
            <div class="row">
                <div class="col-12">
                    <div class="card border shadow-xs mb-4">
                        <div class="row justify-content-center" style="padding:1%;">

                            <div class="col-md-6 col-lg-6 col-sm-12">
                                <form action="{{ route('assign-template') }}" method="POST" enctype="multipart/form-data">
                                    @csrf

                                    <!-- Master Templates Selection -->
                                    <div class="form-group">
                                        <label for="master_template">Choose Master Template:</label>
                                        <div class="row">
                                            <select name="master_template" id="master_template" class="form-control" required>
                                                <option value="" selected disabled>Select Template</option>
                                                <optgroup label="📷 Image Templates">
                                                    @foreach($templates as $template)
                                                    <option value="{{ $template->id }}" data-type="image">{{ $template->name }}</option>
                                                    @endforeach
                                                </optgroup>
                                                <optgroup label="🎥 Video Templates">
                                                    @foreach($videoTemplates as $videoTemplate)
                                                    <option value="{{ $videoTemplate->id }}" data-type="video">{{ $videoTemplate->name }}</option>
                                                    @endforeach
                                                </optgroup>
                                            </select>
                                        </div>
                                    </div>

                                    <!-- Hidden field to store template type -->
                                    <input type="hidden" name="template_type" id="template_type" value="image">

                                    <!-- User Selection -->
                                    <div class="form-group mt-4">
                                        <label for="user">Choose User:</label>
                                        <select name="user" id="user" class="form-control" required>
                                            <option value="" disabled selected>Select a user</option>
                                            @foreach($customers as $user)
                                            <option value="{{ $user->id }}">{{ $user->name }}</option>
                                            @endforeach
                                        </select>
                                    </div>

                                    <!-- Upload User's Template -->
                                    <div class="form-group mt-4">
                                        <label for="user_template">Upload User's Template:</label>
                                        <input type="file" name="user_template" id="user_template" class="form-control" required>
                                    </div>

                                    <!-- Submit Button -->
                                    <button type="submit" class="btn btn-primary mt-4">Assign Template</button>
                                </form>
                            </div>

                            <div class="col-md-6 col-lg-6 col-sm-12">
    <div id="previewContainer_assign" style="display: flex; justify-content: space-between; align-items: center; width: 100%; height: 250px; border: 1px solid #ccc;">
        <img id="master_template_preview" class="image-preview" style="position: relative; height: 100%; width: auto;">
        <img id="user_template_preview" class="image-preview" style="position: relative; height: 100%; width: auto;">
    </div>
</div>




                            <!-- <form class="form-group col-md-6 col-md-6 col-sm-12 col-xs-12" action="{{route('create-template')}}" method="POST" enctype="multipart/form-data">

                                @csrf
                                <label>Name</label>
                                <div class="mb-3">
                                    <input type="text" id="name" name="name" class="form-control" placeholder="Enter your  Template name" aria-label="Name" aria-describedby="name-addon">
                                    @error('name')
                                    <span class="text-danger text-sm">{{ $message }}</span>
                                    @enderror
                                </div>

                                <label for="image">Upload Template</label>
                                <div class="mb-3">
                                    <input type="file" id="image" name="image" class="form-control" aria-label="Image" aria-describedby="image-addon">
                                    @error('image')
                                    <span class="text-danger text-sm">{{ $message }}</span>
                                    @enderror
                                </div>

                                <div class="text-center">
                                    <button type="submit" class="btn btn-dark w-100 mt-4 mb-3">Create Template</button>

                                </div>

                            </form> -->

                        </div>
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
    // Handle master template preview on dropdown change
    $('#master_template').change(function() {
        const templateId = $(this).val();
        const templateType = $(this).find(':selected').data('type');
        
        // Update hidden field with template type
        $('#template_type').val(templateType);
        
        if (templateId) {
            if (templateType === 'image') {
                fetchTemplateImage(templateId, '#master_template_preview');
            } else if (templateType === 'video') {
                fetchVideoTemplateImage(templateId, '#master_template_preview');
            }
        } else {
            $('#master_template_preview').attr('src', '');
        }
    });

    // Function to fetch image template image via AJAX
    function fetchTemplateImage(templateId, previewId) {
        $.ajax({
            url: '{{ url('/get-template-image') }}/' + templateId,
            method: 'GET',
            success: function(response) {
                const templateImage = response.image;
                if (templateImage) {
                    const templateImageUrl = '{{ asset('img/master_template') }}' + '/' + templateImage;
                    $(previewId).attr('src', templateImageUrl);
                } else {
                    $(previewId).attr('src', '');
                }
            },
            error: function(xhr, status, error) {
                console.error(error);
            }
        });
    }

    // Function to fetch video template image via AJAX
    function fetchVideoTemplateImage(templateId, previewId) {
        $.ajax({
            url: '{{ url('/get-video-template-image') }}/' + templateId,
            method: 'GET',
            success: function(response) {
                const templateImage = response.image;
                if (templateImage) {
                    const templateImageUrl = '{{ asset('img/master_template') }}' + '/' + templateImage;
                    $(previewId).attr('src', templateImageUrl);
                } else {
                    $(previewId).attr('src', '');
                }
            },
            error: function(xhr, status, error) {
                console.error(error);
            }
        });
    }

    // Trigger master template preview update initially if a template is already selected
    const selectedTemplateId = $('#master_template').val();
    if (selectedTemplateId) {
        const templateType = $('#master_template').find(':selected').data('type');
        if (templateType === 'image') {
            fetchTemplateImage(selectedTemplateId, '#master_template_preview');
        } else if (templateType === 'video') {
            fetchVideoTemplateImage(selectedTemplateId, '#master_template_preview');
        }
    }

    // Handle user template preview on file input change
    $('#user_template').change(function() {
        const file = this.files[0];
        if (file) {
            const reader = new FileReader();
            reader.onload = function(e) {
                $('#user_template_preview').attr('src', e.target.result);
            };
            reader.readAsDataURL(file);
        }
    });
});


</script>