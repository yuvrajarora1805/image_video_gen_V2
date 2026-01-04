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
                        
                        <div class="row justify-content-center">



                            <form class="form-group col-md-6 col-md-6 col-sm-12 col-xs-12" action="{{route('create-video-template')}}" method="POST" enctype="multipart/form-data">

                                @csrf
                                <label>Name</label>
                                <div class="mb-3">
                                    <input type="text" id="name" name="name" class="form-control" placeholder="Enter your Video Template name" aria-label="Name" aria-describedby="name-addon">
                                    @error('name')
                                    <span class="text-danger text-sm">{{ $message }}</span>
                                    @enderror
                                </div>

                                <label for="video">Upload Video Template</label>
                                <div class="mb-3">
                                    <input type="file" id="video" name="video" class="form-control" accept="video/mp4,video/x-m4v,video/*" aria-label="Video" aria-describedby="video-addon">
                                    @error('video')
                                    <span class="text-danger text-sm">{{ $message }}</span>
                                    @enderror
                                </div>

                                <div class="text-center">
                                    <button type="submit" class="btn btn-dark w-100 mt-4 mb-3">Create Video Template</button>

                                </div>

                            </form>

                        </div>
                    </div>
                </div>
            </div>

            <x-app.footer />
        </div>
    </main>

</x-app-layout>
