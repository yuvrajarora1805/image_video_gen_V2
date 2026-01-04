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


                            </div>
                        </div>

                        <div class="row justify-content-center">



                            <form class="form-group col-md-6 col-md-6 col-sm-12 col-xs-12" action="{{route('createuser')}}" method="POST" enctype="multipart/form-data">

                                @csrf
                                <label>Customer Name</label>
                                <div class="mb-3">
                                    <input type="text" id="name" name="name" class="form-control" placeholder="Enter Customer name" aria-label="Name" aria-describedby="name-addon" required>
                                    @error('name')
                                    <span class="text-danger text-sm">{{ $message }}</span>
                                    @enderror
                                </div>
                               
                              
                              

                                <label>WhatsApp Group Name</label>
                                <div class="mb-3">
                                    <input type="text" id="groupname" name="groupname" class="form-control" placeholder="Enter Whatsapp Group Name" aria-label="groupname" aria-describedby="groupname-addon" required>
                                    @error('groupname')
                                    <span class="text-danger text-sm">{{ $message }}</span>
                                    @enderror
                                </div>

                                <div class="text-center">
                                    <button type="submit" class="btn btn-dark w-100 mt-4 mb-3">Create User</button>

                                </div>

                            </form>

                        </div>




                    </div>
                </div>
            </div>
        </div>
        <x-app.footer />
    </main>

</x-app-layout>

<script src="/assets/js/plugins/datatables.js"></script>
<script>
    const dataTableBasic = new simpleDatatables.DataTable("#datatable-search", {
        searchable: true,
        fixedHeight: true,
        columns: [{
            select: [2, 6],
            sortable: false
        }]
    });
</script>