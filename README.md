# python-web-scraping

Hands-on workshop material on Web scraping using Python 🛠️⚙️ 

### To build and run site locally :

Execute the following commands

```bash
git clone https://github.com/MonashDataFluency/python-web-scraping.git
cd python-web-scraping
virtualenv -p python3 venv
source venv/bin/activate
pip install -r requirements.txt
mkdocs serve
```

After modifying any notebook content, please run the `./compile.sh` script to update the website or alternatively :
- Run `jupyter nbconvert --output-dir='markdowns/' --to markdown notebooks/*.ipynb` from the root directory to generate the markdown files from jupyter notebooks, and
- Run `mkdocs build` to generate the build the website again. 

> Note : `wptools` might throw an error during installtion, in which case install other dependencies as : 
```bash
sudo apt install libcurl4-openssl-dev libssl-dev  
```
and then proceed to install `wptools` though `pip install -r requirements.txt` as above.