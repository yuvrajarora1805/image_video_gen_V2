import requests
import json

BASE_URL = "http://127.0.0.1:8000/api"
task_id = 10

def main():
    # Get subtasks for the given task
    subtasks_url = f"{BASE_URL}/subtask-list?taskid={task_id}"
    subtasks = requests.get(subtasks_url).json()

    if not subtasks:
        print("No subtasks found for this task.")
        return

    # Get images from the first subtask
    first_subtask_id = subtasks[0]["id"]
    images_url = f"{BASE_URL}/image-list?subtaskid={first_subtask_id}"
    images = requests.get(images_url).json()

    if not images:
        print("No images found for this subtask.")
        return

    # Mark each image as sent
    update_url = f"{BASE_URL}/update-image-status"

    for img in images:
        payload = {"imageId": img["id"]}  # Note: capital I in imageId
        r = requests.post(update_url, json=payload)

        if r.status_code == 200:
            print(f"Marked image {img['id']} as sent")
        else:
            print(f"Failed to update image {img['id']}: {r.text}")

if __name__ == "__main__":
    main()
