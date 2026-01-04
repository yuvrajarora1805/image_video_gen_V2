<style>
    .c-dashboardInfo {
        margin-bottom: 15px;
    }

    .c-dashboardInfo .wrap {
        background: #ffffff;
        box-shadow: 2px 10px 20px rgba(0, 0, 0, 0.1);
        border-radius: 7px;
        text-align: center;
        position: relative;
        overflow: hidden;
        padding: 40px 25px 20px;
        height: 100%;
    }

    .c-dashboardInfo__title,
    .c-dashboardInfo__subInfo {
        color: #6c6c6c;
        font-size: 1.18em;
    }

    .c-dashboardInfo span {
        display: block;
    }

    .c-dashboardInfo__count {
        font-weight: 600;
        font-size: 2.5em;
        line-height: 64px;
        color: #323c43;
    }

    .c-dashboardInfo .wrap:after {
        display: block;
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 10px;
        content: "";
    }

    .c-dashboardInfo:nth-child(1) .wrap:after {
        background: linear-gradient(82.59deg, #00c48c 0%, #00a173 100%);
    }

    .c-dashboardInfo:nth-child(2) .wrap:after {
        background: linear-gradient(81.67deg, #0084f4 0%, #1a4da2 100%);
    }

    .c-dashboardInfo:nth-child(3) .wrap:after {
        background: linear-gradient(69.83deg, #0084f4 0%, #00c48c 100%);
    }

    .c-dashboardInfo:nth-child(4) .wrap:after {
        background: linear-gradient(81.67deg, #ff647c 0%, #1f5dc5 100%);
    }

    .c-dashboardInfo__title svg {
        color: #d7d7d7;
        margin-left: 5px;
    }

    .MuiSvgIcon-root-19 {
        fill: currentColor;
        width: 1em;
        height: 1em;
        display: inline-block;
        font-size: 24px;
        transition: fill 200ms cubic-bezier(0.4, 0, 0.2, 1) 0ms;
        user-select: none;
        flex-shrink: 0;
    }
</style>

<x-app-layout>

    <main class="main-content position-relative max-height-vh-100 h-100 border-radius-lg ">
        <x-app.navbar />
        <div class="container-fluid py-4 px-5">
            <div class="row">
                <div class="col-md-12">
                    <div class="d-md-flex align-items-center mb-3 mx-2">



                    </div>
                </div>
            </div>
            <hr class="my-0">
            <div class="row">
                <div id="root">
                    <div class="container pt-5">
                        <div class="row align-items-stretch">
                            <div class="c-dashboardInfo col-lg-3 col-md-6">
                                <div class="wrap">
                                    <h4 class="heading heading5 hind-font medium-font-weight c-dashboardInfo__title">Total Customers<svg class="MuiSvgIcon-root-19" focusable="false" viewBox="0 0 24 24" aria-hidden="true" role="presentation">
                                            <path fill="none" d="M0 0h24v24H0z"></path>
                                            <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-6h2v6zm0-8h-2V7h2v2z">
                                            </path>
                                        </svg></h4><span class="hind-font caption-12 c-dashboardInfo__count">{{$totol_customers}}</span>
                                </div>
                            </div>
                            <div class="c-dashboardInfo col-lg-3 col-md-6">
                                <div class="wrap">
                                    <h4 class="heading heading5 hind-font medium-font-weight c-dashboardInfo__title">Total Image Generated<svg class="MuiSvgIcon-root-19" focusable="false" viewBox="0 0 24 24" aria-hidden="true" role="presentation">
                                            <path fill="none" d="M0 0h24v24H0z"></path>
                                            <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-6h2v6zm0-8h-2V7h2v2z">
                                            </path>
                                        </svg></h4><span class="hind-font caption-12 c-dashboardInfo__count">{{$total_gnerate}}</span>
                                </div>
                            </div>
                            <div class="c-dashboardInfo col-lg-3 col-md-6">
                                <div class="wrap">
                                    <h4 class="heading heading5 hind-font medium-font-weight c-dashboardInfo__title">Total Tasks<svg class="MuiSvgIcon-root-19" focusable="false" viewBox="0 0 24 24" aria-hidden="true" role="presentation">
                                            <path fill="none" d="M0 0h24v24H0z"></path>
                                            <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-6h2v6zm0-8h-2V7h2v2z">
                                            </path>
                                        </svg></h4><span class="hind-font caption-12 c-dashboardInfo__count">{{$totoal_task}}</span>
                                </div>
                            </div>
                            <div class="c-dashboardInfo col-lg-3 col-md-6">
                                <div class="wrap">
                                    <h4 class="heading heading5 hind-font medium-font-weight c-dashboardInfo__title">Total Task Executed<svg class="MuiSvgIcon-root-19" focusable="false" viewBox="0 0 24 24" aria-hidden="true" role="presentation">
                                            <path fill="none" d="M0 0h24v24H0z"></path>
                                            <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-6h2v6zm0-8h-2V7h2v2z">
                                            </path>
                                        </svg></h4><span class="hind-font caption-12 c-dashboardInfo__count">{{$complete_task}}</span><span class="hind-font caption-12 c-dashboardInfo__subInfo">Pending : {{$pending_task}}</span>
                                </div>
                            </div>
                            
                            <div class="c-dashboardInfo col-lg-3 col-md-6">
                                <div class="wrap">
                                    <h4 class="heading heading5 hind-font medium-font-weight c-dashboardInfo__title">Total Sent Images<svg class="MuiSvgIcon-root-19" focusable="false" viewBox="0 0 24 24" aria-hidden="true" role="presentation">
                                            <path fill="none" d="M0 0h24v24H0z"></path>
                                            <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-6h2v6zm0-8h-2V7h2v2z">
                                            </path>
                                        </svg></h4><span class="hind-font caption-12 c-dashboardInfo__count">{{$total_sent}}</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        
            <div class="row my-4">

                <div class="col-lg-12 col-md-6">
                    <div class="card shadow-xs border">
                        <div class="card-header border-bottom pb-0">
                            <div class="d-sm-flex align-items-center mb-3">
                                <div>
                                    <h6 class="font-weight-semibold text-lg mb-0">Recent Genrated Images</h6>
                                    <p class="text-sm mb-sm-0 mb-2">These are details about the today's transactions</p>
                                </div>
                               
                            </div>
                         
                        </div>
                        <div class="card-body px-0 py-0">
                            <div class="table-responsive p-0">
                                <table class="table align-items-center justify-content-center mb-0">
                                    <thead class="bg-gray-100">
                                        <tr>
                                            <th class="text-secondary text-xs font-weight-semibold opacity-7">
                                                S.NO.</th>
                                            <th class="text-secondary text-xs font-weight-semibold opacity-7 ps-2">
                                                Customer Name</th>

                                            <th class="text-secondary text-xs font-weight-semibold opacity-7 ps-2">
                                                Genrated Image</th>
                                                <th class="text-secondary text-xs font-weight-semibold opacity-7 ps-2">Sent Status</th>
                                          
                                            <th class="text-center text-secondary text-xs font-weight-semibold opacity-7">
                                                Generate Time
                                            </th>
                                        </tr>
                                    </thead>
                                    <tbody>

                                        @if(isset($today_generate))
                                        <?php $sno = 0; ?>
                                        @foreach($today_generate as $item)

                                        <?php $sno++; ?>
                                        <tr>
                                            <td>{{$sno}}</td>
                                            <td>{{$item->name}}</td>
                                            <td style="width: 35%;"><img src="{{ asset('img/generated_image/' . $item->genarted_image) }}" alt="Generated Image" height="10%" width="10%"></td>
                                            <td>{{ $item->sent == 0 ? 'Not Sent' : 'Sent Successfully' }}</td>
                                          

                                            <td>{{ date('h:i:s A', strtotime($item->created_at)) }}</td>

                                        </tr>

                                        @endforeach


                                        @else
                                        <tr>No Image Generated Today</tr>
                                        @endif
                                    </tbody>
                                </table>
                                <div class="border-top py-3 px-3 d-flex align-items-center">
                                    @if ($today_generate->onFirstPage())
                                    <button class="btn btn-sm btn-white d-sm-block d-none mb-0" disabled>Previous</button>
                                    @else
                                    <a class="btn btn-sm btn-white d-sm-block d-none mb-0" href="{{ $today_generate->previousPageUrl() }}">Previous</a>
                                    @endif

                                    <nav aria-label="..." class="ms-auto">
                                        <ul class="pagination pagination-light mb-0">
                                            @foreach ($today_generate->links()->elements as $element)
                                            @if (is_string($element))
                                            <li class="page-item disabled"><span class="page-link font-weight-bold">{{ $element }}</span></li>
                                            @endif

                                            @if (is_array($element))
                                            @foreach ($element as $page => $url)
                                            @if ($page == $today_generate->currentPage())
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

                                    @if ($today_generate->hasMorePages())
                                    <a class="btn btn-sm btn-white d-sm-block d-none mb-0 ms-auto" href="{{ $today_generate->nextPageUrl() }}">Next</a>
                                    @else
                                    <button class="btn btn-sm btn-white d-sm-block d-none mb-0 ms-auto" disabled>Next</button>
                                    @endif
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </main>

</x-app-layout>