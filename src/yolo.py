from locust import HttpUser, task, between

document_url = "TODO"
ocrs_url = "TODO"

# Host: https://api-internal.conciergerie-digitale.cloud
class YoloUser(HttpUser):
    # wait_time = between(3, 8)

    @task
    def call_yolo(self):
        self.client.post("/yolo/api/v1/yolo", json={
			"document_url": document_url,
			"ocrs_url": ocrs_url,
		})
