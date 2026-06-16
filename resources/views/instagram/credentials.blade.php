<x-app-layout>
    <main class="main-content position-relative max-height-vh-100 h-100 border-radius-lg">
        <div class="container-fluid py-4">
            <div class="row">
                <div class="col-12">
                    <div class="card">
                        <div class="card-header pb-0 d-flex justify-content-between align-items-center">
                            <div>
                                <h5 class="mb-0">Instagram API Credentials</h5>
                                <p class="text-sm mb-0">Manage your Instagram API access tokens and user IDs</p>
                            </div>
                            <div class="d-flex align-items-center">
                                <a href="{{ route('instagram.permanent-token') }}" class="btn btn-outline-primary btn-sm mb-0 me-2">
                                    <i class="fas fa-magic me-2"></i>Permanent Token Tool
                                </a>
                                <button class="btn btn-primary btn-sm mb-0" data-bs-toggle="modal" data-bs-target="#addCredentialModal">
                                    <i class="fas fa-plus me-2"></i>Add Credential
                                </button>
                            </div>
                        </div>
                        <div class="card-body px-0 pt-0 pb-2">
                            @if($credentials->count() > 0)
                                <div class="table-responsive p-0">
                                    <table class="table align-items-center mb-0">
                                        <thead>
                                            <tr>
                                                <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Credential Name</th>
                                                <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7 ps-2">Customer</th>
                                                <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7 ps-2">IG User ID</th>
                                                <th class="text-center text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Status</th>
                                                <th class="text-center text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Last Used</th>
                                                <th class="text-center text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Expires</th>
                                                <th class="text-secondary opacity-7"></th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            @foreach($credentials as $credential)
                                                <tr>
                                                    <td>
                                                        <div class="d-flex px-2 py-1">
                                                            <div class="d-flex flex-column justify-content-center">
                                                                <h6 class="mb-0 text-sm">{{ $credential->credential_name }}</h6>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        @if($credential->customer)
                                                            <p class="text-xs font-weight-bold mb-0">{{ $credential->customer->name }}</p>
                                                            <p class="text-xs text-secondary mb-0">{{ $credential->customer->email }}</p>
                                                        @else
                                                            <span class="badge badge-sm bg-gradient-info">Personal</span>
                                                        @endif
                                                    </td>
                                                    <td>
                                                        <p class="text-xs font-weight-bold mb-0">{{ $credential->ig_user_id }}</p>
                                                    </td>
                                                    <td class="align-middle text-center text-sm">
                                                        @if($credential->is_active)
                                                            <span class="badge badge-sm bg-gradient-success">Active</span>
                                                        @else
                                                            <span class="badge badge-sm bg-gradient-secondary">Inactive</span>
                                                        @endif
                                                    </td>
                                                    <td class="align-middle text-center">
                                                        <span class="text-secondary text-xs font-weight-bold">
                                                            {{ $credential->last_used_at ? $credential->last_used_at->diffForHumans() : 'Never' }}
                                                        </span>
                                                    </td>
                                                    <td class="align-middle text-center">
                                                        <span class="text-secondary text-xs font-weight-bold">
                                                            @if($credential->expires_at)
                                                                {{ $credential->expires_at->format('M d, Y') }}
                                                                @if($credential->isExpired())
                                                                    <span class="badge badge-sm bg-gradient-danger ms-1">Expired</span>
                                                                @endif
                                                            @else
                                                                Never
                                                            @endif
                                                        </span>
                                                    </td>
                                                    <td class="align-middle">
                                                        <button class="btn btn-link text-info text-gradient px-2 mb-0" 
                                                                onclick="testCredential({{ $credential->id }})"
                                                                title="Test Credential">
                                                            <i class="fas fa-check-circle text-sm me-1"></i> Test
                                                        </button>
                                                        <button class="btn btn-link text-dark text-gradient px-2 mb-0" 
                                                                onclick="editCredential({{ $credential->id }})"
                                                                title="Edit">
                                                            <i class="fas fa-pencil-alt text-sm me-1"></i> Edit
                                                        </button>
                                                        <button class="btn btn-link text-danger text-gradient px-2 mb-0" 
                                                                onclick="deleteCredential({{ $credential->id }})"
                                                                title="Delete">
                                                            <i class="fas fa-trash text-sm me-1"></i> Delete
                                                        </button>
                                                    </td>
                                                </tr>
                                            @endforeach
                                        </tbody>
                                    </table>
                                </div>
                            @else
                                <div class="text-center py-5">
                                    <i class="fas fa-key fa-3x text-secondary mb-3"></i>
                                    <p class="text-secondary mb-0">No credentials added yet. Click "Add Credential" to get started.</p>
                                </div>
                            @endif
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <!-- Add/Edit Credential Modal -->
    <div class="modal fade" id="addCredentialModal" tabindex="-1" aria-labelledby="addCredentialModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addCredentialModalLabel">Add Instagram Credential</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="credentialForm">
                        <input type="hidden" id="credentialId" name="credential_id">
                        
                        <div class="mb-3">
                            <label for="customerId" class="form-label">Customer (Optional)</label>
                            <select class="form-select" id="customerId" name="customer_id">
                                <option value="">Personal Account</option>
                                @if(isset($customers) && $customers->count() > 0)
                                    @foreach($customers as $customer)
                                        <option value="{{ $customer->id }}">{{ $customer->name }} ({{ $customer->email }})</option>
                                    @endforeach
                                @else
                                    <option value="" disabled>No customers found - Create customers first</option>
                                @endif
                            </select>
                            <small class="text-muted">
                                @if(isset($customers) && $customers->count() > 0)
                                    Select a customer to link this credential, or leave as Personal
                                @else
                                    No customers available. <a href="{{ route('createuser') }}" target="_blank">Create a customer</a> to link credentials.
                                @endif
                            </small>
                        </div>

                        <div class="mb-3">
                            <label for="credentialName" class="form-label">Credential Name</label>
                            <input type="text" class="form-control" id="credentialName" name="credential_name" 
                                   placeholder="e.g., Main Account" required>
                            <small class="text-muted">A friendly name to identify this credential</small>
                        </div>

                        <div class="mb-3">
                            <label for="accessToken" class="form-label">Access Token</label>
                            <textarea class="form-control" id="accessToken" name="access_token" rows="3" 
                                      placeholder="Paste your Instagram Access Token here" required></textarea>
                            <small class="text-muted">Your Instagram Graph API access token</small>
                        </div>

                        <div class="mb-3">
                            <label for="igUserId" class="form-label">Instagram User ID</label>
                            <input type="text" class="form-control" id="igUserId" name="ig_user_id" 
                                   placeholder="e.g., 17841478123611469" required>
                            <small class="text-muted">Your Instagram Business Account ID</small>
                        </div>

                        <div class="mb-3">
                            <label for="facebookPageId" class="form-label">Facebook Page ID (Optional)</label>
                            <input type="text" class="form-control" id="facebookPageId" name="facebook_page_id" 
                                   placeholder="e.g., 921733587691767">
                            <small class="text-muted">Required for uploading to Facebook. Find it in your Facebook Page settings.</small>
                        </div>

                        <div class="mb-3">
                            <label for="expiresAt" class="form-label">Expires At (Optional)</label>
                            <input type="date" class="form-control" id="expiresAt" name="expires_at">
                            <small class="text-muted">When this token expires (if applicable)</small>
                        </div>

                        <div class="form-check form-switch mb-3" id="activeToggleContainer" style="display: none;">
                            <input class="form-check-input" type="checkbox" id="isActive" name="is_active" checked>
                            <label class="form-check-label" for="isActive">Active</label>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary" onclick="saveCredential()">Save Credential</button>
                </div>
            </div>
        </div>
    </div>

    <script>
        let editMode = false;

        function resetForm() {
            document.getElementById('credentialForm').reset();
            document.getElementById('credentialId').value = '';
            document.getElementById('customerId').value = '';
            document.getElementById('addCredentialModalLabel').textContent = 'Add Instagram Credential';
            document.getElementById('activeToggleContainer').style.display = 'none';
            editMode = false;
        }

        // Reset form when modal is closed
        document.getElementById('addCredentialModal').addEventListener('hidden.bs.modal', resetForm);

        function saveCredential() {
            const formData = new FormData(document.getElementById('credentialForm'));
            const credentialId = document.getElementById('credentialId').value;
            const url = credentialId ? `{{ url('/instagram/credentials') }}/${credentialId}` : '{{ url('/instagram/credentials') }}';
            const method = credentialId ? 'PUT' : 'POST';

            const data = {
                customer_id: formData.get('customer_id') || null,
                credential_name: formData.get('credential_name'),
                access_token: formData.get('access_token'),
                ig_user_id: formData.get('ig_user_id'),
                facebook_page_id: formData.get('facebook_page_id') || null,
                expires_at: formData.get('expires_at'),
                is_active: formData.get('is_active') === 'on'
            };

            fetch(url, {
                method: method,
                headers: {
                    'Content-Type': 'application/json',
                    'X-CSRF-TOKEN': '{{ csrf_token() }}'
                },
                body: JSON.stringify(data)
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert(data.message);
                    location.reload();
                } else {
                    alert('Error: ' + JSON.stringify(data.errors));
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('An error occurred while saving the credential');
            });
        }

        function editCredential(id) {
            // Fetch credential data and populate form
            fetch(`{{ url('/instagram/credentials') }}/${id}`)
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        const credential = data.credential;
                        document.getElementById('credentialId').value = credential.id;
                        document.getElementById('customerId').value = credential.customer_id || '';
                        document.getElementById('credentialName').value = credential.credential_name;
                        document.getElementById('accessToken').value = credential.access_token;
                        document.getElementById('igUserId').value = credential.ig_user_id;
                        document.getElementById('facebookPageId').value = credential.facebook_page_id || '';
                        document.getElementById('expiresAt').value = credential.expires_at ? credential.expires_at.split('T')[0] : '';
                        document.getElementById('isActive').checked = credential.is_active;
                        document.getElementById('activeToggleContainer').style.display = 'block';
                        document.getElementById('addCredentialModalLabel').textContent = 'Edit Instagram Credential';
                        editMode = true;
                        
                        const modal = new bootstrap.Modal(document.getElementById('addCredentialModal'));
                        modal.show();
                    }
                });
        }

        function deleteCredential(id) {
            if (!confirm('Are you sure you want to delete this credential?')) {
                return;
            }

            fetch(`{{ url('/instagram/credentials') }}/${id}`, {
                method: 'DELETE',
                headers: {
                    'X-CSRF-TOKEN': '{{ csrf_token() }}'
                }
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert(data.message);
                    location.reload();
                } else {
                    alert('Error deleting credential');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('An error occurred while deleting the credential');
            });
        }

        function testCredential(id) {
            const btn = event.target.closest('button');
            const originalHtml = btn.innerHTML;
            btn.innerHTML = '<i class="fas fa-spinner fa-spin text-sm me-1"></i> Testing...';
            btn.disabled = true;

            fetch(`{{ url('/instagram/credentials') }}/${id}/test`, {
                method: 'POST',
                headers: {
                    'X-CSRF-TOKEN': '{{ csrf_token() }}'
                }
            })
            .then(response => response.json())
            .then(data => {
                btn.innerHTML = originalHtml;
                btn.disabled = false;
                
                if (data.success) {
                    alert(`✓ Credentials Test Results:\n\n${data.message}`);
                } else {
                    alert(`✗ Credential Test Failed:\n\n${data.message}`);
                }
            })
            .catch(error => {
                btn.innerHTML = originalHtml;
                btn.disabled = false;
                console.error('Error:', error);
                alert('An error occurred while testing the credential');
            });
        }
    </script>
</x-app-layout>
