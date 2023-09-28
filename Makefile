



build:
	docker-compose build

run:
	docker run --rm -p 3838:3838 hclwizard-docker_shiny

bash:
	bash login-to-bash


prodbuild:
	docker-compose -f docker-compose.yml -f production.yml up -d
