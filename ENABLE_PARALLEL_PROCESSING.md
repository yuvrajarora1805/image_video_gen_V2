# Enable Parallel Video Processing

To enable parallel video processing (3x faster for bulk generation):

## Step 1: Add to .env file

Add this line to your `.env` file:

```
USE_PARALLEL_PROCESSING=true
```

## Step 2: Restart Laravel (if using queue workers)

```bash
php artisan config:clear
php artisan cache:clear
```

## How It Works

- **1-2 videos**: Uses sequential processing (no benefit from parallel)
- **3+ videos**: Uses parallel processing with 3 workers
- **Speed improvement**: 3x faster for bulk operations

## Performance Example

### Sequential (Current):
- 10 videos × 15 seconds = **150 seconds**

### Parallel (With setting enabled):
- 10 videos ÷ 3 workers × 15 seconds = **50 seconds**
- **3x faster!**

## System Requirements

- 12 CPU cores (you have this ✅)
- 4GB RAM minimum
- SSD recommended for best performance

## To Disable

Set in `.env`:
```
USE_PARALLEL_PROCESSING=false
```

Or remove the line entirely (defaults to sequential).

---

**Note:** The parallel processing system is already built into your code at line 594 of `VideoGenerationController.php`. Just needs to be enabled!
