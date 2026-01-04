<x-app-layout>

    <main class="main-content position-relative max-height-vh-100 h-100 border-radius-lg">
        <x-app.navbar />
        <div class="container-fluid py-4 px-5">
            <div class="row">
                <div class="col-12">
                    <div class="card card-background card-background-after-none align-items-start mt-4 mb-5">
                        <div class="full-background" style="background-image: url('{{ asset('assets/img/header-blue-purple.jpg') }}')"></div>
                        <div class="card-body text-start p-4 w-100">
                            <h3 class="text-white mb-2">Generated Videos 🔥</h3>
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
                        <div class="card-header pb-0 d-flex justify-content-between align-items-center">
                            <h6>Video Generation Tasks</h6>
                            <div class="d-flex align-items-center gap-2">
                                <span class="badge bg-secondary" id="gpuStatus">
                                    <i class="fas fa-microchip me-1"></i>
                                    GPU: <span id="gpuStatusText">Loading...</span>
                                </span>
                                <button type="button" class="btn btn-sm btn-outline-primary" id="toggleGpuBtn" onclick="toggleGPU()">
                                    <i class="fas fa-power-off me-1"></i>
                                    Toggle GPU
                                </button>
                            </div>
                        </div>
                        <div class="card-body px-0 pt-0 pb-2">
                            <div class="table-responsive p-0">
                                <table class="table align-items-center mb-0">
                                    <thead>
                                        <tr>
                                            <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Sno</th>
                                            <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Task Name</th>
                                            <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Total Videos</th>
                                            <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Status</th>
                                            <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Created At</th>
                                            <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Finished At</th>
                                            <th class="text-secondary opacity-7">Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        @if(isset($tasks) && $tasks->count() > 0)
                                            @foreach($tasks as $index => $item)
                                            <tr>
                                                <td class="align-middle bg-transparent border-bottom">
                                                    <p class="text-xs font-weight-bold mb-0">{{ $index + 1 }}</p>
                                                </td>
                                                <td class="align-middle bg-transparent border-bottom">
                                                    <p class="text-xs font-weight-bold mb-0">{{ $item->taskname }}</p>
                                                </td>
                                                <td class="align-middle bg-transparent border-bottom">
                                                    <p class="text-xs mb-0">{{ $item->totalvideos ?? 0 }}</p>
                                                </td>
                                                <td class="align-middle bg-transparent border-bottom">
                                                    <span class="badge badge-sm bg-gradient-{{ $item->status == 1 ? 'success' : ($item->status == 2 ? 'warning' : 'secondary') }}">
                                                        {{ $item->remark }}
                                                    </span>
                                                </td>
                                                <td class="align-middle bg-transparent border-bottom">
                                                    <p class="text-xs mb-0">{{ $item->created_at->format('d M Y H:i') }}</p>
                                                </td>
                                                <td class="align-middle bg-transparent border-bottom">
                                                    <p class="text-xs mb-0">{{ !empty($item->finished_at) ? \Carbon\Carbon::parse($item->finished_at)->format('d M Y H:i') : "Not yet" }}</p>
                                                </td>
                                                <td class="text-center align-middle bg-transparent border-bottom">
                                                    @if ($item->status == 0)
                                                    <form method="POST" action="{{ url('/execute-video-task/' . $item->id) }}" style="display:inline;" onsubmit="this.querySelector('button').textContent='Executing...'; this.querySelector('button').disabled=true; return confirm('Execute this video generation task?');">
                                                        @csrf
                                                        <button type="submit" class="btn btn-sm btn-primary">Execute</button>
                                                    </form>
                                                    <button class="deleteVideoBtn btn btn-sm btn-danger" data-id="{{ $item->id }}">Delete</button>
                                                    @elseif ($item->status == 1)
                                                    <button class="viewVideosBtn btn btn-sm btn-info" data-id="{{ $item->id }}">View Videos</button>
                                                    <a href="/download-task-videos/{{ $item->id }}" class="btn btn-sm btn-success">Download All</a>
                                                    @elseif ($item->status == 2)
                                                    <div class="progress-container" data-task-id="{{ $item->id }}">
                                                        <div class="progress" style="height: 10px;">
                                                            <div class="progress-bar bg-gradient-info progress-bar-striped progress-bar-animated" 
                                                                 role="progressbar" 
                                                                 style="width: {{ $item->percentage ?? 0 }}%" 
                                                                 aria-valuenow="{{ $item->percentage ?? 0 }}" 
                                                                 aria-valuemin="0" 
                                                                 aria-valuemax="100" 
                                                                 id="progress-bar-{{ $item->id }}"></div>
                                                        </div>
                                                        <p class="text-xs mt-1 mb-0 text-center" id="progress-text-{{ $item->id }}">
                                                            Running... (Wait)
                                                        </p>
                                                    </div>
                                                    @endif
                                                </td>
                                            </tr>
                                            @endforeach
                                        @else
                                            <tr>
                                                <td colspan="7" class="text-center py-4">
                                                    <p class="text-sm mb-0">No video tasks found. <a href="{{ route('generate-video-form') }}">Create a new task</a></p>
                                                </td>
                                            </tr>
                                        @endif
                                    </tbody>
                                </table>
                            </div>
                            @if(isset($tasks))
                            <div class="px-3">
                                {{ $tasks->links() }}
                            </div>
                            @endif
                        </div>
                    </div>
                </div>
            </div>
            <x-app.footer />
        </div>
    </main>


</x-app-layout>

<meta name="csrf-token" content="{{ csrf_token() }}">
<script>
document.addEventListener('DOMContentLoaded', function() {
    const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
    
    // Execute Video Button
    document.addEventListener('click', function(e) {
        if (e.target && e.target.classList.contains('executeVideoBtn')) {
            const taskId = e.target.getAttribute('data-id');
            const button = e.target;
            
            if (!confirm('Execute this video generation task?')) {
                return;
            }
            
            button.disabled = true;
            button.textContent = 'Processing...';
            
            fetch('{{ url('/execute-video-task') }}/' + taskId, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-CSRF-TOKEN': csrfToken
                }
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert('Video task executed successfully!');
                    location.reload();
                } else {
                    alert(data.message || 'Error executing task');
                    button.disabled = false;
                    button.textContent = 'Execute';
                }
            })
            .catch(error => {
                alert('Error executing task: ' + error.message);
                button.disabled = false;
                button.textContent = 'Execute';
            });
        }
        
        // View Videos Button
        if (e.target && e.target.classList.contains('viewVideosBtn')) {
            const taskId = e.target.getAttribute('data-id');
            window.location.href = '/test-video-api.html?taskId=' + taskId;
        }
        
        // Download All Button
        if (e.target && e.target.classList.contains('downloadAllBtn')) {
            const taskId = e.target.getAttribute('data-id');
            window.location.href = '/download-task-videos/' + taskId;
        }
        
        // Delete Button
        if (e.target && e.target.classList.contains('deleteVideoBtn')) {
            const taskId = e.target.getAttribute('data-id');
            
            if (!confirm('Are you sure you want to delete this task?')) {
                return;
            }
            
            alert('Delete functionality to be implemented');
        }
    });
    
    // Load GPU status on page load
    loadGPUStatus();

    // Start polling for active tasks
    startTaskPolling();
});

function startTaskPolling() {
    const activeTasks = document.querySelectorAll('.progress-container');
    
    activeTasks.forEach(container => {
        const taskId = container.getAttribute('data-task-id');
        pollTaskProgress(taskId);
    });
}

function pollTaskProgress(taskId) {
    const interval = setInterval(() => {
        fetch(`{{ url('/api/video-task-progress') }}/${taskId}`)
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    const progressBar = document.getElementById(`progress-bar-${taskId}`);
                    const progressText = document.getElementById(`progress-text-${taskId}`);
                    
                    if (progressBar && progressText) {
                        // Update Progress UI
                        progressBar.style.width = `${data.percentage}%`;
                        progressBar.setAttribute('aria-valuenow', data.percentage);
                        progressText.textContent = `${data.percentage}% Completed (${data.generated}/${data.total})`;
                        
                        // If finished
                        if (data.status == 1 || data.percentage >= 100) {
                            clearInterval(interval);
                            progressText.textContent = 'Completed! Reloading...';
                            setTimeout(() => location.reload(), 1000);
                        }
                    }
                }
            })
            .catch(error => console.error('Error polling task:', error));
    }, 2000); // Poll every 2 seconds
}

// Toggle GPU Acceleration
function toggleGPU() {
    const btn = document.getElementById('toggleGpuBtn');
    btn.disabled = true;
    btn.innerHTML = '<i class="fas fa-spinner fa-spin me-1"></i> Updating...';
    
    fetch('{{ url('/api/toggle-gpu') }}', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]').content
        }
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            // Update status display
            const statusText = document.getElementById('gpuStatusText');
            const statusBadge = document.getElementById('gpuStatus');
            
            let statusMessage = '';
            let badgeClass = 'badge ';
            
            if (data.enabled && data.available) {
                // GPU is enabled and available
                statusMessage = `Enabled (${data.encoder || 'Unknown'})`;
                badgeClass += 'bg-success';
            } else if (data.enabled && !data.available) {
                // GPU is enabled but not available
                statusMessage = 'Enabled (No GPU Detected)';
                badgeClass += 'bg-warning';
            } else {
                // GPU is disabled
                statusMessage = 'Disabled';
                badgeClass += 'bg-secondary';
            }
            
            statusText.textContent = statusMessage;
            statusBadge.className = badgeClass;
            statusBadge.title = data.message || '';
            
            // Show success message
            showAlert(data.message || 'GPU acceleration toggled successfully!', 'success');
        } else {
            showAlert('Failed to toggle GPU acceleration: ' + (data.message || 'Unknown error'), 'danger');
        }
    })
    .catch(error => {
        console.error('Error:', error);
        showAlert('Error toggling GPU acceleration', 'danger');
    })
    .finally(() => {
        btn.disabled = false;
        btn.innerHTML = '<i class="fas fa-power-off me-1"></i> Toggle GPU';
    });
}

// Load current GPU status
function loadGPUStatus() {
    fetch('{{ url('/api/gpu-status') }}')
        .then(response => response.json())
        .then(data => {
            const statusText = document.getElementById('gpuStatusText');
            const statusBadge = document.getElementById('gpuStatus');
            
            if (data.success) {
                let statusMessage = '';
                let badgeClass = 'badge ';
                
                if (data.enabled && data.available) {
                    // GPU is enabled and available
                    statusMessage = `Enabled (${data.encoder || 'Unknown'})`;
                    badgeClass += 'bg-success';
                } else if (data.enabled && !data.available) {
                    // GPU is enabled but not available
                    statusMessage = 'Enabled (No GPU Detected)';
                    badgeClass += 'bg-warning';
                } else {
                    // GPU is disabled
                    statusMessage = 'Disabled';
                    badgeClass += 'bg-secondary';
                }
                
                statusText.textContent = statusMessage;
                statusBadge.className = badgeClass;
                
                // Add tooltip with detailed message
                statusBadge.title = data.message || '';
            } else {
                statusText.textContent = 'Error';
                statusBadge.className = 'badge bg-danger';
            }
        })
        .catch(error => {
            console.error('Error loading GPU status:', error);
            const statusText = document.getElementById('gpuStatusText');
            const statusBadge = document.getElementById('gpuStatus');
            statusText.textContent = 'Error';
            statusBadge.className = 'badge bg-danger';
        });
}

// Show alert message
function showAlert(message, type) {
    const alertDiv = document.createElement('div');
    alertDiv.className = `alert alert-${type} alert-dismissible fade show`;
    alertDiv.innerHTML = `
        ${message}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    `;
    
    const container = document.querySelector('.container-fluid');
    container.insertBefore(alertDiv, container.firstChild);
    
    setTimeout(() => {
        alertDiv.remove();
    }, 3000);
}


</script>
