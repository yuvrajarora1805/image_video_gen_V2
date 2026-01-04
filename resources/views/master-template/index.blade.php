<style>
    .template-image-container {
        display: flex;
        align-items: center;
        justify-content: center;
    }

    .template-image {
        max-width: 100px;
        /* Limit the image size */
        max-height: 100px;
    }

    .template-name,
    .template-date {
        white-space: nowrap;
        /* Prevent text wrapping */
        overflow: hidden;
        text-overflow: ellipsis;
        /* Add ellipsis for overflowed text */
        text-align: left;
        /* Align text to the left */
    }

    .table-responsive {
        overflow-x: auto;
    }

    
</style>
<x-app-layout>

    <main class="main-content position-relative max-height-vh-100 h-100 border-radius-lg ">
        <x-app.navbar />
        <div class="container-fluid py-4 px-5">
            <div class="row">
                <div class="col-12">
                    <div class="card card-background card-background-after-none align-items-start mt-4 mb-5">
                        <div class="full-background" style="background-image: url('{{ asset('assets/img/header-blue-purple.jpg') }}')"></div>
                        <div class="card-body text-start p-4 w-100">
                            <h3 class="text-white mb-2">Master Templates 🔥</h3>
                            <!-- <p class="mb-4 font-weight-semibold">
                                Check all the advantages and choose the best.
                            </p> -->
                            <!-- <button type="button"
                                class="btn btn-outline-white btn-blur btn-icon d-flex align-items-center mb-0">
                                <span class="btn-inner--icon">
                                    <svg width="14" height="14" viewBox="0 0 14 14"
                                        xmlns="http://www.w3.org/2000/svg" fill="currentColor" class="d-block me-2">
                                        <path fill-rule="evenodd" clip-rule="evenodd"
                                            d="M7 14C10.866 14 14 10.866 14 7C14 3.13401 10.866 0 7 0C3.13401 0 0 3.13401 0 7C0 10.866 3.13401 14 7 14ZM6.61036 4.52196C6.34186 4.34296 5.99664 4.32627 5.71212 4.47854C5.42761 4.63081 5.25 4.92731 5.25 5.25V8.75C5.25 9.0727 5.42761 9.36924 5.71212 9.52149C5.99664 9.67374 6.34186 9.65703 6.61036 9.47809L9.23536 7.72809C9.47879 7.56577 9.625 7.2926 9.625 7C9.625 6.70744 9.47879 6.43424 9.23536 6.27196L6.61036 4.52196Z" />
                                    </svg>
                                </span>
                                <span class="btn-inner--text">Watch more</span>
                            </button>
                            <img src="../assets/img/3d-cube.png" alt="3d-cube"
                                class="position-absolute top-0 end-1 w-25 max-width-200 mt-n6 d-sm-block d-none" /> -->
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
                        <div class="card-header border-bottom pb-0">
                            <div class="d-sm-flex align-items-center ">
                                <div>
                                    <h6 class="font-weight-semibold text-lg mb-0">Master Templates List</h6>
                                    <!-- <p class="text-sm">See information about all members</p> -->
                                </div>
                                <div class="ms-auto d-flex">

                                    <a href="{{route('create-template-form')}}" class="btn btn-dark btn-primary">
                                        <i class="fas fa-user-plus me-2"></i> Add Master Template
                                    </a>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-12">
                    <div class="card border shadow-xs mb-4">

                        <div class="card-body px-0 py-0">
                            <div class="container mt-5">
                                <div class="row">
                                    <div class="col-md-3">
                                        <input type="text" id="search" placeholder="Search by Template Name" class="form-control mb-3">
                                    </div>
                                </div>
                                <div class="row">
                                    <div id="template-table" class="table-responsive">
                                        <table class="table text-secondary text-center">
                                            <thead>
                                                <tr>
                                                    <th class="text-uppercase font-weight-bold bg-transparent border-bottom text-secondary" style="width: 15%;">Template Image</th>
                                                    <th class="text-uppercase font-weight-bold bg-transparent border-bottom text-secondary" style="width: 35%;">Template Name</th>
                                                    
                                                    <th class="text-uppercase font-weight-bold bg-transparent border-bottom text-secondary" style="width: 20%;">Total Customers</th>
                                                    <th class="text-uppercase font-weight-bold bg-transparent border-bottom text-secondary" style="width: 20%;">Date</th>
                                                    <th class="text-uppercase font-weight-bold bg-transparent border-bottom text-secondary" style="width: 10%;">Action</th>
                                                </tr>
                                            </thead>
                                            <tbody id="template-data">
                                                <!-- Data will be populated by AJAX -->
                                            </tbody>
                                        </table>
                                        <div id="pagination">
                                            <!-- Pagination will be populated by AJAX -->
                                        </div>
                                    </div>
                                </div>
                            </div>


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
        function fetch_data(page, query) {
            $.ajax({
                url: "{{ route('template') }}?page=" + page + "&search=" + query,
                success: function(data) {
                    $('#template-data').html('');
                    if (data.data.length > 0) {
                        $.each(data.data, function(index, item) {
                            $('#template-data').append('<tr>\
                           <td class="align-middle bg-transparent border-bottom template-image-container">\
            <img src="img/master_template/' + item.image + '" class="template-image" alt="template">\
        </td>\
                            <td class="align-middle bg-transparent border-bottom template-name" style="text-align: center !important;">' + item.name + '</td>\
                            <td class="align-middle bg-transparent border-bottom template-name" style="text-align: center !important;">' + item.user_count + '</td>\
                            <td class="align-middle bg-transparent border-bottom template-date" style="text-align: center !important;">' + item.formatted_date + '</td>\
                            <td class="align-middle bg-transparent border-bottom" style="text-align: center !important;">\
                                <button class="btn btn-sm btn-danger delete-template" data-id="' + item.id + '" data-name="' + item.name + '" title="Delete Template">\
                                    <i class="fas fa-trash me-1"></i> Delete\
                                </button>\
                            </td>\
                        </tr>');
                        });
                    } else {
                        $('#template-data').append('<tr><td colspan="5">No records found!!!</td></tr>');
                    }

                    if (data.pagination && data.pagination.trim() !== "") {
                        $('#pagination').html(data.pagination).show();
                    } else {
                        $('#pagination').hide();
                    }
                }
            });
        }

        $(document).on('keyup', '#search', function() {
            var query = $(this).val();
            var page = 1;
            fetch_data(page, query);
        });

        $(document).on('click', '#pagination a', function(event) {
            event.preventDefault();
            var page = $(this).attr('href').split('page=')[1];
            var query = $('#search').val();
            fetch_data(page, query);
        });

        // Delete template
        $(document).on('click', '.delete-template', function() {
            var templateId = $(this).data('id');
            var templateName = $(this).data('name');
            
            if (confirm('Are you sure you want to delete template "' + templateName + '"?')) {
                $.ajax({
                    url: "{{ url('/delete-template') }}/" + templateId,
                    type: 'DELETE',
                    headers: {
                        'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
                    },
                    success: function(response) {
                        if (response.success) {
                            alert(response.message);
                            // Refresh the table
                            var page = 1;
                            var query = $('#search').val();
                            fetch_data(page, query);
                        } else {
                            alert(response.message);
                        }
                    },
                    error: function(xhr) {
                        var errorMessage = 'Error deleting template';
                        if (xhr.responseJSON && xhr.responseJSON.message) {
                            errorMessage = xhr.responseJSON.message;
                        }
                        alert(errorMessage);
                    }
                });
            }
        });

        // Fetch all data initially
        fetch_data(1, '');
    });
</script>