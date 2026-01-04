<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\File;
use Carbon\Carbon;

class ImageGeneration extends Model
{
    use HasFactory;

    protected $table ="generated_image";
    
     protected $fillable = [
        'sent', 'sent_date', 'genarted_path','customer_id','master_template_id','user_template_id','beforeid','taskid','genarted_path','genarted_image','memtype'
    ];
    
    public static function deleteOldImages()
    {
        $images = self::where('created_at', '<', Carbon::now()->subDays(3))->get();

        foreach ($images as $image) {
            $imagePath = public_path('img/generated_image/' . $image->genarted_image);

          
            if (File::exists($imagePath)) {
                File::delete($imagePath);
                // echo "Deleted image: {$image->image_name}\n";
            } else {
                // echo "Image file not found: {$image->image_name}\n";
            }

            
            $image->delete();
        }
    }
}
