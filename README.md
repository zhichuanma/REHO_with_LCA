# Integration the LCA Framework into REHO

This repository documents the process of integrating the Life Cycle Assessment (LCA) framework into the REHO (Renewable 
Energy Hub Optimizer) system, utilizing a series of toolchains.

## Overview

REHO is a decision support tool designed for sustainable urban energy system planning, addressing the optimal design and
operation of capacities. It considers multiple objectives, including economic, environmental, and efficiency criteria. 
However, its current approach to Life Cycle Assessment (LCA) is limited by the quality of its database, meanwhile the 
methodology adapted overlooks the operational phase of the energy systems, focusing on the construction phase and 
resource phase.

Energyscope, another whole-energy system model for regional energy planning, incorporates a well-established and 
comprehensive LCA methodology that encompasses all phases of an energy system’s lifecycle (resource, operation and 
resource). This project aims to integrate the entire LCA framework from Energyscope into REHO, including both the 
database and the methodology. 

Thus, this integration will enhance REHO's ability to perform more comprehensive and reliable analyses of district-level 
energy systems. Additionally, it will also allow for meaningful comparisons between these two models based on the same 
methodology, fostering deeper discussions and insights into sustainable energy planning.

## Author

This integration was carried out by Zhichuan MA, a student at École Polytechnique, during his internship at UCLouvain.

Zhichuan MA zhichuan.ma@polytechnique.edu

## License

This project is licensed under the MIT License - see the [LICENSE](./LICENSE) file for details.

## Installation

Clone the repo:
```shell
git clone https://github.com/zhichuanma/REHO_with_LCA.git
```

## Project Structure and Environments

This repository contains multiple components, each located in separate directories and requiring different environments.
Below is an overview of the project structure and the corresponding environment setup instructions for each folder.

### 1. Folder 1: IE_ML_mapping
**Description**: This sub project is to generate mapping files by means of machine learning methods, based on words 
similarity. The output would be the input when generating LCA database with double counting removal. It's based on 
[Industrial Ecology Machine Learning Mapping](https://github.com/CIRAIG/IE_ML_mapping)

**Environment**:
- **Dependencies**: `./IE_ML_mapping/requirements.txt`
- **Environment Setup**:
  1. Navigate to the directory:
     ```sh
     cd path/to/IE_ML_mapping
     ```
  2. Set up the environment:
  - Install necessary module with pip
    ```sh
       pip install -r requirements.txt
       ```
  - If using `virtualenv`:
    ```sh
    python -m venv env
    source env/bin/activate  # On Windows use `env\Scripts\activate`
    pip install -r requirements.txt
    ```

### 2. Folder 2: REHO
**Description**: This is the main tool I used for the optimization.

**Environment**:

Please refer to [Getting Started](https://reho.readthedocs.io/en/main/sections/5_Getting_started.html) for further 
information

### 3. Folder 3: REHO_db_mescal
**Description**: This is for generating the database and do the double counting removal, on the basis of 
[mescal](https://mescal.readthedocs.io/en/latest/content/usage.html).

**Environment**:
- **Environment Setup**:
  1. Navigate to the directory:
     ```sh
     cd path/to/REHO_db_mescal
     ```
  2. Set up the environment:
     You can install mescal via [pip] from [PyPI]:
     ```shell
     $ pip install mescal
     ```
### Additional Notes

- Ensure that the correct environment is activated when working within each specific directory.
- For ease of use, consider naming the environments distinctly to avoid confusion.
