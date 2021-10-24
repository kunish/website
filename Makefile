IMAGE_NAME = website

build:
	docker build -t ${IMAGE_NAME} .

run:
	docker run --name $(IMAGE_NAME) -p 80:80 $(IMAGE_NAME)

dev: build run

clean:
	docker rm -f $(IMAGE_NAME)
	docker image rm -f ${IMAGE_NAME}
