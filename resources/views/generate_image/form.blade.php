<x-app-layout>

    <main class="main-content position-relative max-height-vh-100 h-100 border-radius-lg ">
        <x-app.navbar />
        <div class="container-fluid py-4 px-5">
  <div class="card card-background card-background-after-none align-items-start mt-4 mb-5">
                        <div class="full-background" style="background-image: url('{{ asset('assets/img/header-blue-purple.jpg') }}')"></div>
                        <div class="card-body text-start p-4 w-100">
                            <h3 class="text-white mb-2">Task Create 🔥</h3>

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
                    <h4 class="card-title text-center">Add Task To Generate Image</h4>

                    @if (session('success'))
                    <div class="alert alert-success">
                        {{ session('success') }}
                    </div>
                    @endif

                    @if (session('error'))
                    <div class="alert alert-danger">
                        {{ session('error') }}
                    </div>
                    @endif

                    <div class="row">
                        <div class="col-md-6">
                            <form id="tempForm">
                                <div class="mb-3">
                                    <label for="dropdown" class="form-label">Choose Template</label>
                                    <select id="dropdown" class="form-select">
                                        <option value="">Select</option>
                                        @foreach ($templates as $template)
                                        <option value="{{ $template->id }}">{{ $template->name }}</option>
                                        @endforeach
                                    </select>
                                </div>

                                <div class="mb-3">
                                    <label for="imageUpload" class="form-label">Upload Image</label>
                                    <input type="file" id="imageUpload" class="form-control" accept="image/*"  onchange="validateImage(this)">
                                </div>
                                <button type="button" id="addButton" class="btn btn-primary mt-3">Add</button>
                        </div>
                                <div class="col-md-6">
                                    <div id="previewContainer" style="position: relative; width: 33%; height: 250px;  border: 1px solid #ccc;">
                                        <img id="uploadPreview" class="image-preview" style="position: absolute;  height: 100%;">
                                        <img id="templatePreview" class="image-preview" style="position: absolute; height: 100%;">
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
                                    <th>Uploaded Image</th>
                                    <th>Total Image</th>
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

function validateImage(input) {
    if (input.files && input.files[0]) {
        const reader = new FileReader();
        
        reader.onload = function (e) {
            const img = new Image();
            img.src = e.target.result;

            img.onload = function () {
                const width = this.width;
                const height = this.height;

                // Check if dimensions are 1080x1080 or 1:1 aspect ratio
                if (width === 1080 && height === 1080) {
                    // Valid image dimensions
                    // Proceed with file upload
                    // You can add your file upload logic here
                } else if (width === height) {
                    // Valid 1:1 aspect ratio
                    // Proceed with file upload
                    // You can add your file upload logic here
                } else {
                    // Invalid image dimensions
                    // Alert the user or perform other actions as needed
                    alert('Image dimensions must be 1080x1080 pixels or in a 1:1 aspect ratio.');
                    // Clear the file input to allow the user to select a new image
                    input.value = '';
                }
            };
        };

        reader.readAsDataURL(input.files[0]);
    }
}


    $(document).ready(function() {
        $.ajaxSetup({
            headers: {
                'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
            }
        });

        // Handle image preview for uploaded image
        $('#imageUpload').change(function() {
            const file = this.files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    $('#uploadPreview').attr('src', e.target.result);
                };
                reader.readAsDataURL(file);
            }
        });

        // Fetch and display template image when template is changed
        $('#dropdown').change(function() {
            const templateId = $(this).val();
            if (templateId) {
                fetchTemplateImage(templateId);
            } else {
                // Clear template preview if no template is selected
                $('#templatePreview').attr('src', '');
            }
        });

        // Function to fetch template image via AJAX
        function fetchTemplateImage(templateId) {
            $.ajax({
                url: '/get-template-image/' + templateId, 
                method: 'GET',
                success: function(response) {
                    const templateImage = response.image; 
                    if (templateImage) {
                        const templateImageUrl = '{{ asset('img/master_template') }}'+'/'+templateImage; 
                        $('#templatePreview').attr('src', templateImageUrl);
                    } else {
                        
                        $('#templatePreview').attr('src', '');
                    }
                },
                error: function(xhr, status, error) {
                    console.error(error);
                }
            });
        }

        // Add row to temp table
        $('#addButton').click(function() {
            const selectedOption = $('#dropdown').val();
            const imageFile = $('#imageUpload')[0].files[0];
            if (!selectedOption || !imageFile) {
                alert('Please select a template and upload an image.');
                return;
            }

            const formData = new FormData();
            formData.append('_token', $('meta[name="csrf-token"]').attr('content'));
            formData.append('option', selectedOption);
            formData.append('image', imageFile);

            // Make AJAX request to add data to temp table
            $.ajax({
                url: '{{ route('tempdata') }}',
                method: 'POST',
                data: formData,
                processData: false,
                contentType: false,
                success: function(response) {

                    if (response.success) {
                        console.log(response.id)
                        const newRow = `<tr>
                        <td>${response.name}</td>
                        <td><img src="${URL.createObjectURL(imageFile)}" class="image-preview" style="width:10%; height="10%";></td>
                        <td>${response.total_image}</td>
                        <td><button type="button" class="deleteButton" data-id="${response.id}">Delete</button></td>
                    </tr>`;
                        $('#tempTable tbody').append(newRow);
                        $('#dropdown').val('');
                        $('#imageUpload').val('');
                        $('#uploadPreview').attr('src', '');
                        $('#templatePreview').attr('src', '');
                    } else {
                        alert(response.error);
                    }
                },
                error: function(xhr) {
                    console.error(xhr.responseText);
                }
            });


        });

        // Delete row from temp table
        $('#tempTable').on('click', '.deleteButton', function() {
            const id = $(this).data('id');
            const row = $(this).closest('tr');

            $.ajax({
                url: '{{ route('tempdata.delete') }}',
                method: 'POST',
                data: {
                    id: id
                },
                success: function(response) {
                    if (response.success) {
                        row.remove();
                    } else {
                        alert(response.error);
                    }
                },
                error: function(xhr) {
                    console.error(xhr.responseText);
                }
            });
        });


        // submit button

        
        
    });


    $(document).ready(function() {
    $('#submitButton').click(function() {
        // Make an AJAX request to trigger the backend method
        $.ajax({
            url: '{{ route('process-temp-data') }}',
            method: 'POST',
            success: function(response) {
                if (response.success) {
                    // Show alert with the task name received from the backend
                    alert('Task created: ' + response.task_name);

                    // Remove all rows from the temporary table
                    $('#tempTable tbody').empty();
                } else {
                    console.error('Failed to process temporary data');
                }
            },
            error: function(xhr) {
                console.error(xhr.responseText);
            }
        });
    });
});

</script>