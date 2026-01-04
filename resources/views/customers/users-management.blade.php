<x-app-layout>
    <main class="main-content position-relative max-height-vh-100 h-100 border-radius-lg ">
        <x-app.navbar />
        <div class="px-5 py-4 container-fluid">
            <div class="row">
                <div class="col-12">
                    <div class="card card-background card-background-after-none align-items-start mt-4 mb-5">
                        <div class="full-background" style="background-image: url('{{ asset('assets/img/header-blue-purple.jpg') }}')"></div>
                        <div class="card-body text-start p-4 w-100">
                            <h3 class="text-white mb-2">Customer Management 🔥</h3>
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

            <div class="mt-4 row">
                <div class="col-12">

                    <div class="card">
                        <div class="pb-0 card-header">
                            <div class="row">
                                <div class="col-6">
                                    <h5 class="">Customer Management</h5>
                                    <p class="mb-0 text-sm">
                                        Here you can manage Customers.
                                    </p>
                                </div>
                                <div class="col-6 text-end">
                                    <a href="{{route('createuser')}}" class="btn btn-dark btn-primary">
                                        <i class="fas fa-user-plus me-2"></i> Add Customer
                                    </a>
                                </div>
                            </div>
                        </div>
                     

                        <div class="container mt-5">
                            <div class="ow">
                                <div class="col-md-3"> <input type="text" id="search" placeholder="Search by Customer Name or WhatsApp group" class="form-control mb-3"></div>
                            </div>
                            <div class="row">
                                <div id="user-table" class="table-responsive">
                                    <table class="table text-secondary text-center">
                                        <thead>
                                            <tr>
                                                <th class="text-left text-uppercase font-weight-bold bg-transparent border-bottom text-secondary">S.No. </th>
                                                <th class="text-left text-uppercase font-weight-bold bg-transparent border-bottom text-secondary">Customer Name</th>
                                                
                                                <th class="text-center text-uppercase font-weight-bold bg-transparent border-bottom text-secondary">Whatsapp Group</th>
                                                <th class="text-center text-uppercase font-weight-bold bg-transparent border-bottom text-secondary">Creation Date</th>
                                                <th class="text-center text-uppercase font-weight-bold bg-transparent border-bottom text-secondary">Action</th>
                                            </tr>
                                            
                                        </thead>
                                        <tbody id="user-data">
                                        </tbody>
                                    </table>
                                    <div id="pagination">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <x-app.footer />
    </main>

</x-app-layout>
<meta name="csrf-token" content="{{ csrf_token() }}">

<!-- DataTables library not available, table will display without sorting/search -->
<!-- <script src="/assets/js/plugins/datatables.js"></script> -->
<script>
    // Commenting out datatable initialization as library is missing
    /*
    const dataTableBasic = new simpleDatatables.DataTable("#datatable-search", {
        searchable: true,
        fixedHeight: true,
        columns: [{
            select: [2, 6],
            sortable: false
        }]
    */
    // });
</script>




<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jqueryui/1.12.1/jquery-ui.min.js"></script>
<script>
    $(document).ready(function() {
        function setupAutocomplete(elementId) {
            $("#" + elementId).autocomplete({
                source: function(request, response) {
                    $.ajax({
                        url: '{{ url('/search') }}', // Replace with your server-side search endpoint
                        dataType: 'json',
                        data: {
                            term: request.term,
                            field: elementId // Send the field id to identify the input
                        },
                        success: function(data) {
                            response(data);
                        }
                    });
                },
                minLength: 2
            });
        }

        setupAutocomplete('customerName1');
        setupAutocomplete('customerName2');
        setupAutocomplete('customerName3');
    });
</script>

<!-- <script>
    $(document).ready(function() {
        function fetch_data(page, query) {
            $.ajax({
                url: "{{ route('users-management') }}?page=" + page + "&search=" + query,
                success: function(data) {
                    $('#user-data').html('');
                    if (data.data.length > 0) {
                        var sno = 1;
                        $.each(data.data, function(index, user) {
                            $('#user-data').append('<tr>\
                                <td class="align-middle bg-transparent border-bottom">' + sno++ + '</td>\
                                <td class="align-middle bg-transparent border-bottom">' + user.name + '</td>\
                                <td class="align-middle bg-transparent border-bottom">' + user.whatsappgroup + '</td>\
                                <td class="align-middle bg-transparent border-bottom">' + user.formatted_date + '</td>\
                            </tr>');
                        });
                    } else {
                        $('#user-data').append('<tr><td colspan="7">No records found!!!</td></tr>');
                    }
                    $('#pagination').html(data.pagination);
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

        
        fetch_data(1, '');
    });
</script> -->


<!--<script>-->
<!--    $(document).ready(function() {-->
<!--        function fetch_data(page, query) {-->
<!--            $.ajax({-->
<!--                url: "/users-management?page=" + page + "&search=" + query,-->
<!--                success: function(data) {-->
<!--                    $('#user-data').html('');-->
<!--                    if (data.data.length > 0) {-->
<!--                        var sno = 1;-->
<!--                        $.each(data.data, function(index, user) {-->
<!--                            $('#user-data').append('<tr>\-->
<!--                                <td class="align-middle bg-transparent border-bottom">' + sno++ + '</td>\-->
<!--                                <td class="align-middle bg-transparent border-bottom">' + user.name + '</td>\-->
<!--                                <td class="align-middle bg-transparent border-bottom">' + user.whatsappgroup + '</td>\-->
<!--                                <td class="align-middle bg-transparent border-bottom">' + user.formatted_date + '</td>\-->
<!--                            </tr>');-->
<!--                        });-->
<!--                    } else {-->
<!--                        $('#user-data').append('<tr><td colspan="7">No records found!!!</td></tr>');-->
<!--                    }-->

<!--                    if (data.pagination && data.pagination.trim() !== "") {-->
<!--                        $('#pagination').html(data.pagination).show();-->
<!--                    } else {-->
<!--                        $('#pagination').hide();-->
<!--                    }-->
<!--                }-->
<!--            });-->
<!--        }-->

<!--        $(document).on('keyup', '#search', function() {-->
<!--            var query = $(this).val();-->
<!--            var page = 1;-->
<!--            fetch_data(page, query);-->
<!--        });-->

<!--        $(document).on('click', '#pagination a', function(event) {-->
<!--            event.preventDefault();-->
<!--            var page = $(this).attr('href').split('page=')[1];-->
<!--            var query = $('#search').val();-->
<!--            fetch_data(page, query);-->
<!--        });-->

        // Fetch all data initially
<!--        fetch_data(1, '');-->
<!--    });-->
<!--</script>-->

<script>
    $(document).ready(function() {
        function fetch_data(page, query) {
            $.ajax({
                url: "{{ route('users-management') }}?page=" + page + "&search=" + query,
                success: function(data) {
                    $('#user-data').html('');
                    if (data.data.length > 0) {
                        var sno = 1;
                        $.each(data.data, function(index, user) {
                            $('#user-data').append('<tr data-user-id="' + user.id + '">\
                                <td class="align-middle bg-transparent border-bottom">' + sno++ + '</td>\
                                <td class="align-middle bg-transparent border-bottom">' + user.name + '</td>\
                                <td class="align-middle bg-transparent border-bottom">' + user.whatsappgroup + '</td>\
                                <td class="align-middle bg-transparent border-bottom">' + user.formatted_date + '</td>\
                                <td><button class="btn btn-danger btn-sm delete-user-btn" data-user-id="' + user.id + '">Delete</button></td>\
                            </tr>');
                        });
                    } else {
                        $('#user-data').append('<tr><td colspan="7">No records found!!!</td></tr>');
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

    
        fetch_data(1, '');


        $(document).on('click', '.delete-user-btn', function() {
            var userId = $(this).data('user-id');
            deleteUser(userId);
        });

        // Function to delete user
        function deleteUser(userId) {
            $.ajax({
                url: '{{ url('/delete-user') }}/' + userId,
                type: 'DELETE',
                headers: {
                    'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
                },
                success: function(result) {
                    console.log('User deleted:', result);
                    // Remove deleted user row from table
                    $('#user-data').find('tr[data-user-id="' + userId + '"]').remove();
                },
                error: function(error) {
                    console.error('Error deleting user:', error);
                }
            });
        }

    });
</script>




