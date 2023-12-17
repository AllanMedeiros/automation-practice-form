# automation-practice-form
Demo QA test automation code example using Robot Framework, Python, Selenium and Gherkin syntax.

## Selenium standalone image with Chrome
docker pull selenium/standalone-chrome:120.0

Start the container
docker run -d -p 4444:4444 -p 7900:7900 --shm-size="2g" selenium/standalone-chrome:120.0