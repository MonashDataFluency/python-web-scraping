# python-web-scraping

Hands-on workshop material on Web scraping using Python 🛠️⚙️ 

### To build and run site locally :

1. git clone https://github.com/MonashDataFluency/python-web-scraping.git
2. cd python-web-scraping
3. virtualenv -p python3 venv
4. source venv/bin/activate
5. pip install -r requirements.txt
6. mkdocs serve

Note : `wptools` might throw an error during installtion, in which case install other dependencies as : 
- sudo apt install libcurl4-openssl-dev libssl-dev  

and then proceed to install `wptools` (included in step 5 above)

Note: After modifying any notebook content, please run the `./compile.sh` script to update the website or alternatively :
- Run `jupyter nbconvert --output-dir='markdowns/' --to markdown notebooks/*.ipynb` from the root directory to generate the markdown files from jupyter notebooks, and
- Run `mkdocs build` to generate the build the website again. 