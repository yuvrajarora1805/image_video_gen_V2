<?php

use Illuminate\Support\Facades\Route;

// Temporary route to reset task 20
Route::get('/reset-task-20-temp', function () {
    try {
        $updated = DB::table('tasks')
            ->where('id', 20)
            ->update([
                'status' => 0,
                'remark' => 'Pending Execution',
                'finished_at' => null
            ]);
        
        $task = DB::table('tasks')->where('id', 20)->first();
        
        return response()->json([
            'success' => true,
            'message' => 'Task reset successfully',
            'rows_updated' => $updated,
            'current_status' => [
                'id' => $task->id,
                'status' => $task->status,
                'remark' => $task->remark,
                'finished_at' => $task->finished_at
            ]
        ]);
    } catch (\Exception $e) {
        return response()->json([
            'success' => false,
            'error' => $e->getMessage()
        ], 500);
    }
});
