# Introduction

Hi! Welcome to the ACES-Temoa repository. This repo contains the code behind
the Atlantic Canada Energy System (ACES) Model, which is based off the [Temoa](https://temoacloud.com/)
modelling suite. In fact, this repository is simply a clone of the Temoa [GitHub repository](https://github.com/TemoaProject/temoa)
repository. The clone was made on January 1, 2022. This was done to allow us to make code
additions specific to the Atlantic Canadian context that did not exist in the core Temoa code. 

Please take a look at the [commit history](https://github.com/SutubraResearch/ACES-Temoa/commits/energysystem) for a summary of 
the changes made to the core Temoa code. We've done our best to pull in recent commits from Temoa 
when it makes sense to. Any commit in our commit history pulled in from the core Temoa repository
is marked with "(copy)" in its title. A link to the original commit is available in the commit
message. Any commit without "(copy)" in its title is unique to this repositroy. 

This is one of three repositories related to the ACES Model. The others are:
- The [ACES-Data](https://github.com/SutubraResearch/ACES-Data) repository contains the data files
associated with the ACES Model.
- The [ACES-Dashboard](https://github.com/SutubraResearch/ACES-Dashboard) repository contains the files
associated with the data visualization dashboard.

We use distinct repositories to separate the distinct software elements of the project. 

The remainder of this README is from the original Temoa repository. 

# Overview

The 'energysystem' branch is the current master branch of
Temoa.  The four subdirectories are:

1. `temoa_model/`
Contains the core Temoa model code.

2. `data_files/`
Contains simple input data (DAT) files for Temoa. Note that the file 
'utopia-15.dat' represents a simple system called 'Utopia', which 
is packaged with the MARKAL model generator and has been used 
extensively for benchmarking exercises.

3. `data_processing/`
Contains several modules to make output graphs, network diagrams, and 
results spreadsheets.

3. `tools/`
Contains scripts used to conduct sensitivity and uncertainty analysis. 
See the READMEs inside each subfolder for more information.

4. `docs/`
Contains the source code for the Temoa project manual, in reStructuredText
(ReST) format.

## Creating a Temoa Environment

Temoa requires several software elements, and it is most convenient to create 
a conda environment in which to run the model. To begin, you need to have conda 
installed either via miniconda or anaconda. Next, download the environment.yml file, 
and  place in a new directory named 'temoa-py3.' Create this new directory in 
a location where you wish to store the environment. From the command line:

```$ conda env create```

Then activate the environment as follows:

```$ source activate temoa-py3```

This new conda environment contains several elements, including Python 3, a 
compatible version of Pyomo, matplotlib, numpy, scipy, and two free solvers 
(GLPK and CBC). A note for Windows users: the CBC solver is not available for Windows through conda. Thus, in order to install the environment properly, the last line of the 'environment.yml' file specifying 'coincbc' should be deleted.

To download the Temoa source code, either clone the repository or download from GitHub 
as a zip file.

## Running Temoa

To run Temoa, you have a few options. All commands below should be executed from the 
top-level 'temoa' directory.

**Option 1 (full-featured):**
Invokes python directly, and gives the user access to 
several model features via a configuration file:

```$ python  temoa_model/  --config=temoa_model/config_sample```

Running the model with a config file allows the user to (1) use a sqlite 
database for storing input and output data, (2) create a formatted Excel 
output file, (2) specify the solver to use, (3) return the log file produced during model execution, (4) return the lp file utilized by the solver, and (5) to execute modeling-to-generate alternatives (MGA). Note that if you do not have access to a commercial solver, it may be faster run cplex on the NEOS server. To do so, simply specify cplex as the solver and uncomment the '--neos' flag.


**Option 2 (basic):**
Uses Pyomo's own scripts and provides basic solver output:

```$ pyomo solve --solver=<solver> temoa_model/temoa_model.py  path/to/dat/file```

This option will only work with a text ('DAT') file as input. 
Results are placed in a yml file within the top-level 'temoa' directory.


**Option 3 (basic +):**
Copies the relevant Temoa model files into an executable archive 
(this only needs to be done once):

```$ python create_archive.py```

This makes the model more portable by placing all contents in a 
single zipped file. Now it is possible to execute the model with the 
following simply command:

```$ python temoa.py  path/to/dat/file```

For general help use --help:

```$ python  temoa_model/  --help```



