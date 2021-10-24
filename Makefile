IMAGE_NAME = website

dev:
	docker build -t ${IMAGE_NAME} .
	docker run --name $(IMAGE_NAME) -p 80:80 $(IMAGE_NAME)

clean:
	docker image rm -f ${IMAGE_NAME}
