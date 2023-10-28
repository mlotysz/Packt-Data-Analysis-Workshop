set dotenv-load

# list available recipes, see: https://github.com/casey/just for documentation
@default:
  just --list
  just --choose

# install dependencies
_install-deps:
  venv/bin/python -m pip install --upgrade pip \
  && venv/bin/pip install -r requirements.txt

# activate virtual environment
@venv:
  virtualenv -q venv \
  && echo "Virtual environment created. Run:" \
  && echo "    source venv/bin/activate" \
  && echo "to activate it!" \
  && source venv/bin/activate \
  just install-deps

# this is meant to be used in developer mode
_install-deps-dev:
  python -m pip install --upgrade pip \
  && python -m pip install --upgrade \
    pip-upgrader pylint flake8 \
  && pip install -r requirements.txt \
  && pip install jupyter

# install dependencies + extra developer tools
@venv-dev:
  virtualenv -q venv-dev \
  && echo "Virtual DEV environment created. Run:" \
  && echo "    source venv-dev/bin/activate" \
  && echo "to activate it!" \
  && source venv-dev/bin/activate \
  && just _install-deps-dev

# upgrade dependencies
upgrade:
  source venv-dev/bin/activate && pip-upgrade

# recreate requirements.txt file
create-dependencies:
  venv/bin/pip freeze > requirements.txt

# run jypyter notebook
jupyter:
    source venv-dev/bin/activate \
    && jupyter notebook \
    --ip='*' --port=8888 \
    --allow-root

# # run unit tests
# @test:
#   source venv-dev/bin/activate \
#   && python -m unittest -v

# remove temporary files in local
@clean:
  find . -type d -name '__pycache__' -exec rm -rf {} +
  find . -type d -name '.pytest_cache' -exec rm -rf {} +
  find . -type f -name '*.py[co]' -exec rm -f {} +
  find . -name '*~' -exec rm -f {} +
