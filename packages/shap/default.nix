{ lib
, buildPythonPackage
, fetchFromGitHub
, writeText
, isPy27
, pytestCheckHook
, pytest-mpl
, numpy
, scipy
, scikit-learn
, pandas
, transformers
, opencv4
, lightgbm
, catboost
, pyspark
, sentencepiece
, tqdm
, slicer
, numba
, matplotlib
, nose
, lime
, cloudpickle
, ipython
}:

buildPythonPackage rec {
  pname = "shap";
  version = "0.41.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-rYVWQ3VRvIObSQPwDRsxhTOGOKNkYkLtiHzVwoB3iJ0=";
  };

  propagatedBuildInputs = [
    numpy
    scipy
    scikit-learn
    pandas
    tqdm
    slicer
    numba
    cloudpickle
  ];

  passthru.optional-dependencies = {
    plots = [ matplotlib ipython ];
    others = [ lime ];
  };

  # TODO FIXME
  doCheck = false;

  meta = with lib; {
    description = "A unified approach to explain the output of any machine learning model";
    homepage = "https://github.com/slundberg/shap";
  };
}