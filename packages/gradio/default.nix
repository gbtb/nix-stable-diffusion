{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, writeTextFile
, setuptools
, analytics-python
, aiohttp
, fastapi
, ffmpy
, markdown-it-py
, linkify-it-py
, mdit-py-plugins
, matplotlib
, numpy
, orjson
, pandas
, paramiko
, pillow
, pycryptodome
, python-multipart
, pydub
, requests
, uvicorn
, jinja2
, fsspec
, httpx
, pydantic
, typing-extensions
, pytest-asyncio
, mlflow
, huggingface-hub
, transformers
, wandb
, respx
, scikitimage
, shap
, ipython
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "gradio";
  version = "3.1.4";
  disabled = pythonOlder "3.7";

  # We use the Pypi release, as it provides prebuild webui assets,
  # and its releases are also more frequent than github tags
  src = fetchPypi {
    inherit pname version;
    sha256 = "5pzOfHDEBdz+HNGoaPwimBKixAZ1K6zD1a0IWLfzfxo=";
  };

  propagatedBuildInputs = [
    analytics-python
    aiohttp
    fastapi
    ffmpy
    matplotlib
    numpy
    orjson
    pandas
    paramiko
    pillow
    pycryptodome
    python-multipart
    pydub
    requests
    uvicorn
    jinja2
    fsspec
    httpx
    pydantic
    markdown-it-py
  ] ++ markdown-it-py.optional-dependencies.plugins
    ++ markdown-it-py.optional-dependencies.linkify;

  postPatch = ''
    # Unpin h11, as its version was only pinned to aid dependency resolution.
    # Basically a revert of https://github.com/gradio-app/gradio/pull/1680
    substituteInPlace requirements.txt \
      --replace "h11<0.13,>=0.11" ""
  '';

  checkInputs = [
    pytestCheckHook
    pytest-asyncio
    mlflow
    #cometml # FIXME: enable once comet-ml is packaged
    huggingface-hub
    transformers
    wandb
    respx
    scikitimage
    shap
    ipython
   ];

  disabledTestPaths = [
    # requires network connection
    "test/test_tunneling.py"
    "test/test_external.py"
  ];

  disabledTests = [
    # requires network connection
    "test_encode_url_to_base64"
    "test_launch_colab_share"
    "test_with_external"
    "test_setup_tunnel"
    "test_url_ok"
    "test_get"
    "test_post"
    "test_validate_with_model"
    "test_validate_with_function"

    # FIXME: enable once comet-ml is packaged
    "test_inline_display"
    "test_integration_comet"

    # Expects a dep to generate a warning. Very sensitive to dep versions
    "test_should_warn_url_not_having_version"

    # FileNotFoundError, most likely flaky tests
    "test_create_tmp_copy_of_file" # 'test.txt' missing
    "test_as_component_as_output" # when moving files in /tmp
    "test_component_functions" # when moving files in /tmp
  ];
  #pytestFlagsArray = [ "-x" "-W" "ignore" ]; # debugging help

  pythonImportsCheck = [ "gradio" ];

  meta = with lib; {
    homepage = "https://www.gradio.app/";
    description = "Python library for easily interacting with trained machine learning models";
    license = licenses.asl20;
    maintainers = with maintainers; [ pbsds ];
  };
}