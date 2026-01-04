<style>
    .template-video-container {
        display: flex;
        align-items: center;
        justify-content: center;
    }

    .template-video {
        max-width: 100px;
        /* Limit the video size */
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
                            <h3 class="text-white mb-2">Video Master Templates 🎬</h3>
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
                                    <h6 class="font-weight-semibold text-lg mb-0">Video Master Templates List</h6>
                                </div>
                                <div class="ms-auto d-flex">
                                    <a href="{{route('create-video-template-form')}}" class="btn btn-dark btn-primary">
                                        <i class="fas fa-video me-2"></i> Add Video Master Template
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
                                                    <th class="text-uppercase font-weight-bold bg-transparent border-bottom text-secondary" style="width: 15%;">Template Video</th>
                                                    <th class="text-uppercase font-weight-bold bg-transparent border-bottom text-secondary" style="width: 45%;">Template Name</th>
                                                    
                                                    <th class="text-uppercase font-weight-bold bg-transparent border-bottom text-secondary" style="width: 45%;">Total Customers</th>
                                                    <th class="text-uppercase font-weight-bold bg-transparent border-bottom text-secondary" style="width: 40%;">Date</th>
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

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    $(document).ready(function() {
        function fetch_data(page, query) {
            $.ajax({
                url: "{{ route('video-template') }}?page=" + page + "&search=" + query,
                success: function(data) {
                    $('#template-data').html('');
                    if (data.data.length > 0) {
                        $.each(data.data, function(index, item) {
                            $('#template-data').append('<tr>\
                           <td class="align-middle bg-transparent border-bottom template-video-container">\
            <video width="100" height="100" controls>\
                <source src="videos/background_video/' + item.video + '" type="video/mp4">\
                Your browser does not support the video tag.\
            </video>\
        </td>\
                            <td class="align-middle bg-transparent border-bottom template-name" style="text-align: center !important;">' + item.name + '</td>\
                            <td class="align-middle bg-transparent border-bottom template-name" style="text-align: center !important;">' + item.user_count + '</td>\
                            <td class="align-middle bg-transparent border-bottom template-date" style="text-align: center !important;">' + item.formatted_date + '</td>\
                        </tr>');
                        });
                    } else {
                        $('#template-data').append('<tr><td colspan="4">No records found!!!</td></tr>');
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

        // Fetch all data initially
        fetch_data(1, '');
    });
</script>
