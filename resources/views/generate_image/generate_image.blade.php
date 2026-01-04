<x-app-layout>

    <main class="main-content position-relative max-height-vh-100 h-100 border-radius-lg ">
        <x-app.navbar />
        <div class="container-fluid py-4 px-5">
        <div class="row">
                <div class="col-12">
                    <div class="card card-background card-background-after-none align-items-start mt-4 mb-5">
                        <div class="full-background" style="background-image: url('{{ asset('assets/img/header-blue-purple.jpg') }}')"></div>
                        <div class="card-body text-start p-4 w-100">
                            <h3 class="text-white mb-2">Generated Images 🔥</h3>
                            
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
                            <h4 class="font-weight-semibold text-lg mb-3">Generate Image</h4>
                        </div>
                        <div class="card-body px-3 py-3">
                            <div class="table-responsive">
                                <table class="table table-striped table-bordered table-sm">
                                    <thead class="table-dark">
                                        <tr>
                                            <th style="width: 5%;">Sno</th>
                                            <th style="width: 20%;">Task Name</th>
                                            <th style="width: 8%;">Total</th>
                                            <th style="width: 10%;">Status</th>
                                            <th style="width: 12%;">Sent Status</th>
                                            <th style="width: 13%;">Added On</th>
                                            <th style="width: 13%;">Finished On</th>
                                            <th style="width: 19%;">Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <?php $sno = 0; ?>
                                        @isset($tasks)

                                        @foreach($tasks as $item)

                                        <?php $sno++ ?>
                                        <tr>
                                            <td class="align-middle">{{$sno}}</td>
                                            <td class="align-middle taskName link" data-id="{{ $item->id }}" style="cursor: pointer;">{{ $item->taskname }}</td>
                                            <td class="align-middle">{{ $item->totalimage }}</td>
                                            <td class="align-middle">{{ $item->remark }}</td>
                                            <td class="text-center align-middle">
                                                @if ($item->sent_status == 0)
                                                <span class="badge" style="background-color: #ff8c00; color: white;">Not Sent</span>
                                                @elseif ($item->sent_status == 1)
                                                <span class="badge" style="background-color: #28a745; color: white;">Sent</span>
                                                @endif
                                            </td>
                                            <td class="align-middle" style="font-size: 0.85rem;">{{ \Carbon\Carbon::parse($item->created_at)->format('d-m-Y H:i') }}</td>
                                            <td class="align-middle" style="font-size: 0.85rem;">{{ !empty($item->finished_at) ? \Carbon\Carbon::parse($item->finished_at)->format('d-m-Y H:i') : "Not yet" }}</td>

                                            <td class="text-center align-middle">
                                                @if ($item->status == 0)
                                                <button class="executeButton btn btn-primary btn-sm mb-1" data-id="{{ $item->id }}">Execute</button>
                                                <button class="deleteButton btn btn-danger btn-sm mb-1" data-id="{{ $item->id }}">Delete</button>
                                                @elseif ($item->status == 2)
                                                <span class="badge" style="background-color: #17a2b8; color: white;">Generated</span>
                                                @elseif ($item->status == 1)
                                                <span class="badge" style="background-color: #17a2b8; color: white;">Generated</span>
                                                @endif
                                            </td>
                                        </tr>
                                        @endforeach
                                        @else
                                        <tr><td colspan="8" class="text-center">No records found!!!</td></tr>
                                        @endisset
                                    </tbody>
                                </table>
                            </div>
                                                    <div class="border-top py-3 px-3 d-flex align-items-center">
                                                        @if ($tasks->onFirstPage())
                                                        <button class="btn btn-sm btn-white d-sm-block d-none mb-0" disabled>Previous</button>
                                                        @else
                                                        <a class="btn btn-sm btn-white d-sm-block d-none mb-0" href="{{ $tasks->previousPageUrl() }}">Previous</a>
                                                        @endif

                                                        <nav aria-label="..." class="ms-auto">
                                                            <ul class="pagination pagination-light mb-0">
                                                                @foreach ($tasks->links()->elements as $element)
                                                                @if (is_string($element))
                                                                <li class="page-item disabled"><span class="page-link font-weight-bold">{{ $element }}</span></li>
                                                                @endif

                                                                @if (is_array($element))
                                                                @foreach ($element as $page => $url)
                                                                @if ($page == $tasks->currentPage())
                                                                <li class="page-item active" aria-current="page">
                                                                    <span class="page-link font-weight-bold">{{ $page }}</span>
                                                                </li>
                                                                @else
                                                                <li class="page-item">
                                                                    <a class="page-link border-0 font-weight-bold" href="{{ $url }}">{{ $page }}</a>
                                                                </li>
                                                                @endif
                                                                @endforeach
                                                                @endif
                                                                @endforeach
                                                            </ul>
                                                        </nav>

                                                        @if ($tasks->hasMorePages())
                                                        <a class="btn btn-sm btn-white d-sm-block d-none mb-0 ms-auto" href="{{ $tasks->nextPageUrl() }}">Next</a>
                                                        @else
                                                        <button class="btn btn-sm btn-white d-sm-block d-none mb-0 ms-auto" disabled>Next</button>
                                                        @endif
                                                    </div>
                                                </div>


                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="row">
                                    <!-- Modal Structure -->
                                    <!-- Modal Structure -->
                                    <div class="modal fade" id="taskDetailsModal" tabindex="-1" role="dialog" aria-labelledby="taskDetailsModalLabel" aria-hidden="true">
                                        <div class="modal-dialog modal-lg" role="document">
                                            <div class="modal-content" style="width: 150% !important;">
                                                <div class="modal-header">
                                                    <h5 class="modal-title" id="taskDetailsModalLabel">Task Details</h5>
                                                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                                        <span aria-hidden="true">&times;</span>
                                                    </button>
                                                </div>
                                                <div class="modal-body">
                                                    <!-- Task Details Content -->
                                                    <table id="taskDetailsTable" class="table table-striped">
                                                        <thead>
                                                            <tr>
                                                                <th>S.No.</th>
                                                                <th>Master Template Name</th>
                                                                <th>Total Image</th>
                                                                <th>Status</th>
                                                                <th>Sent Status</th>
                                                                <th>Finished On</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <!-- Data will be appended here via JavaScript -->
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </div>
                                        </div>
                                    </div>


                                </div>

                                <div class="modal fade" id="userDetailsModal" tabindex="-1" aria-labelledby="userDetailsModalLabel" aria-hidden="true">
    <div class="modal-dialog" >
        <div class="modal-content" style="width: 195% !important;">
            <div class="modal-header">
                <h5 class="modal-title" id="userDetailsModalLabel">User Details</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <table id="userDetailsTable" class="table">
                    <thead>
                        <tr>
                        <th>S. No.</th>
                            <th>Customer Name</th>
                            <th>Generated Image</th>
                            <th>Sent Status</th>
                            <th>Generated Date & Time</th>
                        </tr>
                    </thead>
                    <tbody>
                        <!-- User details will be appended here -->
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
                            </div>


                            <!-- <button id="generatesetup">Generate Image</button>

                            <div id="memberDetails"></div> -->
                        </div>
                    </div>
                </div>
            </div>

            <x-app.footer />
        </div>
    </main>

</x-app-layout>

<meta name="csrf-token" content="{{ csrf_token() }}">
<script src="https://code.jquery.com/jquery-3.7.0.js"></script>

<script>
    $(document).ready(function() {
        $('.executeButton').click(function() {
            var taskId = $(this).data('id');
            var button = $(this);
            button.text('Generated').prop('disabled', true);

            $.ajax({
                url: '{{ route('executeTask', '') }}/' + taskId,
                method: 'POST',
                headers: {
                    'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
                },
                success: function(response) {
                    if (response.success) {
                        $('#status-' + taskId).text('Processing');
                        button.closest('td').html('<span class="processingText">Generated</span>');
                    } else {
                        button.text('Execute').prop('disabled', false);
                        alert(response.message);
                    }
                },
                error: function(xhr) {
                    button.text('Execute').prop('disabled', false);
                    console.error(xhr.responseText);
                }
            });
        });


        // delete

        $('.deleteButton').click(function() {
            var taskId = $(this).data('id');
            var button = $(this);
            const row = $(this).closest('tr');
            button.text('Processing...').prop('disabled', true);

            $.ajax({
                url: '{{ route('deleteTask', '') }}/' + taskId,
                method: 'POST',
                headers: {
                    'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
                },
                success: function(response) {
                    if (response.success) {
                        alert(response.message);
                    } else {
                        button.text('Execute').prop('disabled', false);
                        alert(response.message);
                    }
                },
                error: function(xhr) {
                    button.text('Delete').prop('disabled', false);
                    console.error(xhr.responseText);
                }
            });
        });

        function checkTaskStatus(taskId, button) {
            $.ajax({
                url: '{{ url('/check-task-status') }}', // Replace with your actual endpoint
                type: 'GET',
                data: {
                    id: taskId
                },
                success: function(response) {
                    if (response.status == 1) {
                        button.closest('tr').find('.taskStatus').text('Completed');
                        button.replaceWith('<button class="sendButton btn btn-success" data-id="' + taskId + '">Send</button>');
                    } else if (response.status == 2) {
                        setTimeout(function() {
                            checkTaskStatus(taskId, button);
                        }, 5000); // Check status every 5 seconds
                    } else {
                        button.prop('disabled', false).text('Execute');
                    }
                },
                error: function() {
                    alert('An error occurred while checking task status.');
                    button.prop('disabled', false).text('Execute');
                }
            });
        }

        // Example for sendButton if needed
        $('.sendButton').click(function() {
            var taskId = $(this).data('id');
            var button = $(this);

            $.ajax({
                url: '{{ route('sendTask','') }}/'+ taskId,
                method: 'POST',
                headers: {
                    'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
                },
                success: function(response) {
                    if (response.success) {
                        alert('Task sent successfully.');
                    } else {
                        alert(response.message);
                    }
                },
                error: function(xhr) {
                    console.error(xhr.responseText);
                }
            });
        });
    });
</script>


<!-- fetch data in model -->

<script>
 


    $(document).ready(function() {
    $('.taskName').click(function() {
        var taskId = $(this).data('id');

       
        $('#taskDetailsTable tbody').empty();

       
        $.ajax({
            url: '{{ route('getTaskDetails', '') }}/' + taskId,
            method: 'GET',
            success: function(response) {
                if (response.success) {
                    var details = response.data;
                    var sn = 0;
                    details.forEach(function(item) {
                       sn++
                        if(item.status!== 0)
                        {
                            var row = '<tr>' +
                            '<td >' + sn + '</td>' +
                            '<td >' + item.name + '</td>' +
                            '<td " data-id="' + item.task_count + '">' + item.task_count + '</td>' +
                            '<td>' + (item.status == 1 ? 'Pending' : item.status == 0 ? 'Finished' : 'Processing') + '</td>' +
                            '<td>' + (item.sent_status == 1 ? 'Pending' : item.sent_status == 0 ? 'Success' : 'Pending') + '</td>' +
                            '<td >' + (item.updated_at = null ? 'Not Yet' : date('d-m-Y', strtotime(item.updated_at))) + '</td>' +
                            '</tr>';
                        }
                        else{
                            var row = '<tr>' +
                            '<td >' + sn + '</td>' +
                            '<td class="masterTemplateName link" data-id="' + item.bfid + '">' + item.name + '</td>' +
                            '<td " data-id="' + item.task_count + '">' + item.task_count + '</td>' +
                            '<td>' + (item.status == 1 ? 'Pending' : item.status == 0 ? 'Finished' : 'Processing') + '</td>' +
                            '<td>' + (item.sent_status == 1 ? 'Pending' : item.sent_status == 0 ? 'Success' : 'Pending') + '</td>' +
                            '<td >' + (item.updated_at = null ? 'Not Yet' : item.updated_at) + '</td>' +
                            '</tr>';
                        }
                       
                        $('#taskDetailsTable tbody').append(row);
                    });

                 
                    $('#taskDetailsModal').modal('show');
                } else {
                    alert('Error fetching task details.');
                }
            },
            error: function(xhr) {
                console.error(xhr.responseText);
                alert('An error occurred while fetching task details.');
            }
        });
    });

   
    $(document).on('click', '.masterTemplateName', function() {
        var beforeId = $(this).data('id');
      

        $('#userDetailsTable tbody').empty();

   
        $.ajax({
            url: '{{ route('getUserDetails', '') }}/' + beforeId,
            method: 'GET',
            success: function(response) {
                if (response.success) {
                    var details = response.data;
                    var sn = 0;
                    details.forEach(function(item) {
                        sn++
                        var row = '<tr>' +
                        '<td >' + sn + '</td>' +
                            '<td>' + item.name + '</td>' +
                            '<td><img src="{{ asset('img/generated_image') }}/' + item.genarted_image + '" alt="Generated Image" width="50" height="50"></td>' +
                            '<td>' + (item.sent == 1 ? 'Pending' : item.sent == 0 ? 'Success' : 'Pending') + '</td>' +
                            '<td>' + item.created_at + '</td>' +

                            
                            '</tr>';
                        $('#userDetailsTable tbody').append(row);
                    });

                    // Show the modal
                    $('#userDetailsModal').modal('show');
                } else {
                    alert('Error fetching user details.');
                }
            },
            error: function(xhr) {
                console.error(xhr.responseText);
                alert('An error occurred while fetching user details.');
            }
        });
    });

    // Close modal on close button click
    $('#taskDetailsModal .close').click(function() {
        $('#taskDetailsModal').modal('hide');
    });
    $('#userDetailsModal .close').click(function() {
        $('#userDetailsModal').modal('hide');
    });
});

</script>