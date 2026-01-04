<?php
/**
 * Facebook Token Permission Checker
 * Usage: /check-token-permissions/{credential_id}
 */

require __DIR__.'/../vendor/autoload.php';

$app = require_once __DIR__.'/../bootstrap/app.php';
$kernel = $app->make(Illuminate\Contracts\Http\Kernel::class);

use App\Models\InstagramCredential;

// Get credential ID from URL
$credentialId = $_GET['id'] ?? null;

if (!$credentialId) {
    die(json_encode(['error' => 'Please provide credential ID: ?id=X']));
}

try {
    $credential = InstagramCredential::findOrFail($credentialId);
    
    // Query Facebook Graph API
    $url = "https://graph.facebook.com/v21.0/me/permissions?access_token=" . urlencode($credential->access_token);
    
    $ch = curl_init($url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
    $response = curl_exec($ch);
    $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    curl_close($ch);
    
    $data = json_decode($response, true);
    
    // Required permissions
    $requiredPermissions = [
        'pages_manage_posts' => 'Required to post videos to Facebook Pages',
        'pages_read_engagement' => 'Required to read page engagement data',
        'pages_show_list' => 'Required to list pages',
        'instagram_basic' => 'Required for Instagram access',
        'instagram_content_publish' => 'Required to publish to Instagram'
    ];
    
    $grantedPermissions = [];
    $missingPermissions = [];
    
    if (isset($data['data'])) {
        foreach ($data['data'] as $perm) {
            if ($perm['status'] === 'granted') {
                $grantedPermissions[] = $perm['permission'];
            }
        }
    }
    
    foreach ($requiredPermissions as $perm => $description) {
        if (!in_array($perm, $grantedPermissions)) {
            $missingPermissions[$perm] = $description;
        }
    }
    
    ?>
    <!DOCTYPE html>
    <html>
    <head>
        <title>Token Permissions - <?= htmlspecialchars($credential->credential_name) ?></title>
        <style>
            body { font-family: Arial, sans-serif; margin: 40px; background: #f5f5f5; }
            .container { max-width: 800px; margin: 0 auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
            h1 { color: #333; border-bottom: 3px solid #4267B2; padding-bottom: 10px; }
            h2 { color: #555; margin-top: 30px; }
            .status { padding: 15px; border-radius: 5px; margin: 20px 0; }
            .success { background: #d4edda; border-left: 4px solid #28a745; color: #155724; }
            .error { background: #f8d7da; border-left: 4px solid #dc3545; color: #721c24; }
            .warning { background: #fff3cd; border-left: 4px solid #ffc107; color: #856404; }
            ul { line-height: 1.8; }
            .perm-item { padding: 8px; margin: 5px 0; background: #f8f9fa; border-radius: 4px; }
            .granted { border-left: 3px solid #28a745; }
            .missing { border-left: 3px solid #dc3545; }
            code { background: #e9ecef; padding: 2px 6px; border-radius: 3px; font-family: monospace; }
            .info { background: #d1ecf1; padding: 15px; border-radius: 5px; margin: 20px 0; border-left: 4px solid #0c5460; }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>🔐 Token Permission Checker</h1>
            
            <div class="info">
                <strong>Credential:</strong> <?= htmlspecialchars($credential->credential_name) ?><br>
                <strong>Page ID:</strong> <?= htmlspecialchars($credential->page_id ?? 'N/A') ?><br>
                <strong>IG User ID:</strong> <?= htmlspecialchars($credential->ig_user_id ?? 'N/A') ?>
            </div>
            
            <?php if (empty($missingPermissions)): ?>
                <div class="status success">
                    ✅ <strong>All required permissions are granted!</strong> This token should work for video uploads.
                </div>
            <?php else: ?>
                <div class="status error">
                    ❌ <strong>Missing <?= count($missingPermissions) ?> required permission(s)</strong>
                    <p>This token will NOT work for video uploads until you add the missing permissions.</p>
                </div>
            <?php endif; ?>
            
            <h2>✅ Granted Permissions (<?= count($grantedPermissions) ?>)</h2>
            <ul>
                <?php foreach ($grantedPermissions as $perm): ?>
                    <li class="perm-item granted">
                        <code><?= htmlspecialchars($perm) ?></code>
                        <?php if (isset($requiredPermissions[$perm])): ?>
                            <br><small style="color: #666;"><?= htmlspecialchars($requiredPermissions[$perm]) ?></small>
                        <?php endif; ?>
                    </li>
                <?php endforeach; ?>
            </ul>
            
            <?php if (!empty($missingPermissions)): ?>
                <h2>❌ Missing Required Permissions</h2>
                <ul>
                    <?php foreach ($missingPermissions as $perm => $description): ?>
                        <li class="perm-item missing">
                            <code><?= htmlspecialchars($perm) ?></code>
                            <br><small style="color: #666;"><?= htmlspecialchars($description) ?></small>
                        </li>
                    <?php endforeach; ?>
                </ul>
                
                <div class="status warning">
                    <strong>How to fix:</strong>
                    <ol>
                        <li>Go to <a href="https://developers.facebook.com/tools/explorer" target="_blank">Facebook Graph API Explorer</a></li>
                        <li>Select your app</li>
                        <li>Add the missing permissions listed above</li>
                        <li>Click "Generate Access Token"</li>
                        <li>Update this credential with the new token</li>
                    </ol>
                </div>
            <?php endif; ?>
            
            <h2>📋 Raw API Response</h2>
            <pre style="background: #f8f9fa; padding: 15px; border-radius: 5px; overflow-x: auto;"><?= json_encode($data, JSON_PRETTY_PRINT) ?></pre>
        </div>
    </body>
    </html>
    <?php
    
} catch (Exception $e) {
    ?>
    <!DOCTYPE html>
    <html>
    <head>
        <title>Error</title>
        <style>
            body { font-family: Arial, sans-serif; margin: 40px; background: #f5f5f5; }
            .error { background: #f8d7da; border: 1px solid #f5c6cb; color: #721c24; padding: 20px; border-radius: 5px; max-width: 600px; margin: 0 auto; }
        </style>
    </head>
    <body>
        <div class="error">
            <h2>❌ Error</h2>
            <p><?= htmlspecialchars($e->getMessage()) ?></p>
        </div>
    </body>
    </html>
    <?php
}
