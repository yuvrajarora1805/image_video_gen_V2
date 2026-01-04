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
                        <div class="card-header border-bottom pb-0">
                            <div class="d-sm-flex align-items-center ">
                                <div>
                                    <h6 class="font-weight-semibold text-lg mb-0">Customer Templates List</h6>
                                    <!-- <p class="text-sm">See information about all members</p> -->
                                </div>
                                <div class="ms-auto d-flex">

                                    <a href="{{route('assign-template-form')}}" class="btn btn-dark btn-primary">
                                        <i class="fas fa-user-plus me-2"></i> Add Customer Template
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
                            <div class="row">
                                    <div class="col-md-3 mt-2 mx-2">
                                        <input type="text" id="search" placeholder="Search by Template, Customer, or Template Name" class="form-control mb-3">
                                    </div>
                                </div>
                            <div class="table-responsive p-0">
                                

                                <table class="table align-items-center justify-content-center mb-0">
                                    <thead class="bg-gray-100">
                                        <tr>
                                            <th class="text-secondary text-xs font-weight-semibold opacity-7 ps-2">
                                                Template Image</th>
                                            <th class="text-secondary text-xs font-weight-semibold opacity-7">
                                                Customer Name</th>
                                            <th class="text-secondary text-xs font-weight-semibold opacity-7 ps-2">Template Name</th>
                                            <th class="text-secondary text-xs font-weight-semibold opacity-7 ps-2">Type</th>
                                            <th class="text-secondary text-xs font-weight-semibold opacity-7 ps-2">Date</th>
                                            <th class="text-secondary text-xs font-weight-semibold opacity-7 ps-2">Action</th>
                                       
                                        </tr>
                                    </thead>
                                    <tbody id="template-data">
                                        <!-- Data will be loaded dynamically using AJAX -->
                                    </tbody>
                                </table>
                                <div id="pagination">
                                    <!-- Pagination links will be loaded dynamically using AJAX -->
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
                url: "{{ route('assign') }}?page=" + page + "&search=" + query,
                success: function(data) {
                    try {
                        $('#template-data').html('');
                        if (data.data && data.data.length > 0) {
                            var rows = [];
                            $.each(data.data, function(index, item) {
                                var typeIcon = (item.content_type === 'video') ? '🎥' : '📷';
                                var typeBadge = (item.content_type === 'video') ? 
                                    '<span class="badge bg-gradient-info">Video</span>' : 
                                    '<span class="badge bg-gradient-primary">Image</span>';
                                
                                var customerName = item.name || 'Unknown';
                                var templateName = item.templatename || 'Unknown';
                                var templatePath = item.template_path || '';
                                var createdAt = item.created_at || '';
                                
                                rows.push('<tr>' +
                                    '<td>' +
                                        '<div class="d-flex px-2">' +
                                            '<div class="avatar bg-gray-100 me-2 my-2">' +
                                                '<img src="' + templatePath + '" class="w-100" alt="template" loading="lazy">' +
                                            '</div>' +
                                        '</div>' +
                                    '</td>' +
                                    '<td>' +
                                        '<p class="text-sm font-weight-normal mb-0">' + customerName + '</p>' +
                                    '</td>' +
                                    '<td>' +
                                        '<span class="text-sm font-weight-normal">' + typeIcon + ' ' + templateName + '</span>' +
                                    '</td>' +
                                    '<td>' + typeBadge + '</td>' +
                                    '<td>' +
                                        '<span class="text-sm font-weight-normal">' + createdAt + '</span>' +
                                    '</td>' +
                                    '<td>' +
                                        '<button class="btn btn-danger btn-sm" onclick="deleteItem(' + item.id + ')">Delete</button>' +
                                    '</td>' +
                                '</tr>');
                            });
                            $('#template-data').html(rows.join(''));
                        } else {
                            $('#template-data').html('<tr><td colspan="6" class="text-center">No records found</td></tr>');
                        }

                        if (data.pagination && data.pagination.trim() !== "") {
                            $('#pagination').html(data.pagination).show();
                        } else {
                            $('#pagination').hide();
                        }
                    } catch (e) {
                        console.error('Error rendering data:', e);
                        $('#template-data').html('<tr><td colspan="6" class="text-center text-danger">Error loading data</td></tr>');
                    }
                },
                error: function(xhr, status, error) {
                    console.error('AJAX Error:', error);
                    $('#template-data').html('<tr><td colspan="6" class="text-center text-danger">Failed to load data. Please refresh the page.</td></tr>');
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
        
        // Delete function (moved inside ready to access fetch_data)
        window.deleteItem = function(itemId) {
            if (!confirm('Are you sure you want to delete this template assignment?')) {
                return;
            }
            
            $.ajax({
                url: '{{ url('/delete-item') }}/' + itemId,
                type: 'DELETE',
                headers: {
                    'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
                },
                success: function(result) {
                    console.log('Item deleted:', result);
                    alert('Template assignment deleted successfully!');
                    // Reload the data
                    fetch_data(1, $('#search').val());
                },
                error: function(xhr, status, error) {
                    console.error('Error deleting item:', xhr.responseText);
                    var errorMsg = 'Error deleting template assignment';
                    try {
                        var response = JSON.parse(xhr.responseText);
                        errorMsg = response.message || errorMsg;
                    } catch(e) {
                        errorMsg += ': ' + error;
                    }
                    alert(errorMsg);
                }
            });
        };
    });

    
</script>