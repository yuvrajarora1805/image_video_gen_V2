<aside class="sidenav navbar navbar-vertical navbar-expand-xs border-0 bg-slate-900 fixed-start p-0"
       id="sidenav-main"
       style="height:100vh; overflow:hidden;">

    <!-- Brand -->
    <div class="sidenav-header px-3 py-2 position-sticky top-0 bg-slate-900 z-index-10">
        <i class="fas fa-times p-2 cursor-pointer text-secondary opacity-5 position-absolute end-0 top-0 d-xl-none"
           id="iconSidenav"></i>

        <a class="navbar-brand d-flex align-items-center gap-2 m-0"
           href="{{ route('dashboard') }}">
            <i class="ni ni-box-2 text-primary"></i>
            <span class="font-weight-bold text-sm text-white">UVA Creation</span>
        </a>
    </div>

    <hr class="horizontal light my-0">

    <!-- Menu -->
    <div class="collapse navbar-collapse px-2"
         id="sidenav-collapse-main"
         style="height:calc(100vh - 60px); overflow-y:auto; padding-bottom:40px;">

        <ul class="navbar-nav">

            <!-- Dashboard -->
            <li class="nav-item">
                <a class="nav-link py-1 px-2 {{ request()->routeIs('dashboard') ? 'active bg-gradient-primary text-white' : '' }}"
                   href="{{ route('dashboard') }}">
                    <i class="ni ni-tv-2 text-sm"></i>
                    <span class="ms-2 text-sm">Dashboard</span>
                </a>
            </li>

            <!-- Management -->
            <li class="nav-item mt-2">
                <h6 class="ps-2 mb-1 text-uppercase text-xs font-weight-bolder text-white-50">
                    Management
                </h6>
            </li>

            <li class="nav-item">
                <a class="nav-link py-1 px-2 {{ request()->routeIs('template') ? 'active' : '' }}"
                   href="{{ route('template') }}">
                    <i class="ni ni-app text-info"></i>
                    <span class="ms-2 text-sm">Master Templates</span>
                </a>
            </li>

            <li class="nav-item">
                <a class="nav-link py-1 px-2 {{ request()->routeIs('users-management') ? 'active' : '' }}"
                   href="{{ route('users-management') }}">
                    <i class="ni ni-single-02 text-warning"></i>
                    <span class="ms-2 text-sm">Customer Management</span>
                </a>
            </li>

            <li class="nav-item">
                <a class="nav-link py-1 px-2 {{ request()->routeIs('assign') ? 'active' : '' }}"
                   href="{{ route('assign') }}">
                    <i class="ni ni-tag text-primary"></i>
                    <span class="ms-2 text-sm">Assign Template</span>
                </a>
            </li>

            <!-- Image Generation -->
            <li class="nav-item mt-2">
                <h6 class="ps-2 mb-1 text-uppercase text-xs font-weight-bolder text-white-50">
                    Image Generation
                </h6>
            </li>

            <li class="nav-item">
                <a class="nav-link py-1 px-2 {{ request()->routeIs('template-generate-form') ? 'active' : '' }}"
                   href="{{ route('template-generate-form') }}">
                    <i class="ni ni-fat-add text-success"></i>
                    <span class="ms-2 text-sm">Add Task</span>
                </a>
            </li>

            <li class="nav-item">
                <a class="nav-link py-1 px-2 {{ request()->routeIs('generateimages-form') ? 'active' : '' }}"
                   href="{{ route('generateimages-form') }}">
                    <i class="ni ni-send text-danger"></i>
                    <span class="ms-2 text-sm">Generate & Send Images</span>
                </a>
            </li>

            <li class="nav-item">
                <a class="nav-link py-1 px-2"
                   href="{{ route('generateimages-form') }}">
                    <i class="ni ni-image text-warning"></i>
                    <span class="ms-2 text-sm">View Generated Images</span>
                </a>
            </li>

            <!-- Video Generation -->
            <li class="nav-item mt-2">
                <h6 class="ps-2 mb-1 text-uppercase text-xs font-weight-bolder text-white-50">
                    Video Generation
                </h6>
            </li>

            <li class="nav-item">
                <a class="nav-link py-1 px-2 {{ request()->routeIs('video-template-form') ? 'active' : '' }}"
                   href="{{ route('video-template-form') }}">
                    <i class="ni ni-tv-2 text-primary"></i>
                    <span class="ms-2 text-sm">Video Templates</span>
                </a>
            </li>

            <li class="nav-item">
                <a class="nav-link py-1 px-2 {{ request()->routeIs('generate-video-form') ? 'active' : '' }}"
                   href="{{ route('generate-video-form') }}">
                    <i class="ni ni-button-play text-success"></i>
                    <span class="ms-2 text-sm">Generate & Send Videos</span>
                </a>
            </li>

            <li class="nav-item">
                <a class="nav-link py-1 px-2 {{ request()->routeIs('generate-videos') ? 'active' : '' }}"
                   href="{{ route('generate-videos') }}">
                    <i class="ni ni-collection text-info"></i>
                    <span class="ms-2 text-sm">View Generated Videos</span>
                </a>
            </li>

            <!-- Instagram -->
            <li class="nav-item mt-2">
                <h6 class="ps-2 mb-1 text-uppercase text-xs font-weight-bolder text-white-50">
                    Instagram
                </h6>
            </li>

            <li class="nav-item">
                <a class="nav-link py-1 px-2 {{ request()->routeIs('instagram.credentials') ? 'active' : '' }}"
                   href="{{ route('instagram.credentials') }}">
                    <i class="fab fa-instagram text-danger"></i>
                    <span class="ms-2 text-sm">API Credentials</span>
                </a>
            </li>

            <li class="nav-item">
                <a class="nav-link py-1 px-2 {{ request()->routeIs('instagram.send-customer-videos') ? 'active' : '' }}"
                   href="{{ route('instagram.send-customer-videos') }}">
                    <i class="ni ni-send text-success"></i>
                    <span class="ms-2 text-sm">Send Customer Videos</span>
                </a>
            </li>

            <li class="nav-item">
                <a class="nav-link py-1 px-2 {{ request()->routeIs('instagram.upload-history') ? 'active' : '' }}"
                   href="{{ route('instagram.upload-history') }}">
                    <i class="ni ni-bullet-list-67 text-warning"></i>
                    <span class="ms-2 text-sm">Upload History</span>
                </a>
            </li>

            <li class="nav-item">
                <a class="nav-link py-1 px-2 {{ request()->routeIs('instagram.page-token-fetcher') ? 'active' : '' }}"
                   href="{{ route('instagram.page-token-fetcher') }}">
                    <i class="fab fa-facebook text-info"></i>
                    <span class="ms-2 text-sm">Page Token Fetcher</span>
                </a>
            </li>

            <li class="nav-item">
                <a class="nav-link py-1 px-2 {{ request()->routeIs('instagram.permanent-token') ? 'active' : '' }}"
                   href="{{ route('instagram.permanent-token') }}">
                    <i class="fas fa-magic text-primary"></i>
                    <span class="ms-2 text-sm text-primary font-weight-bold">Permanent Token Tool</span>
                </a>
            </li>

            <li class="nav-item">
                <a class="nav-link py-1 px-2 {{ request()->routeIs('instagram.master-uploader') ? 'active' : '' }}"
                   href="{{ route('instagram.master-uploader') }}">
                    <i class="ni ni-cloud-upload-96 text-success"></i>
                    <span class="ms-2 text-sm">Master Uploader</span>
                </a>
            </li>

        </ul>
    </div>
</aside>
