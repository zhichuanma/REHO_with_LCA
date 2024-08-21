from reho.model.reho import *

import pandas as pd

if __name__ == '__main__':

    INDICATORS = [
        "CCEQL", "CCEQS", "CCHHL", "CCHHS", "MAL", "MAS", "PCOX", "FWEXS", "HTXCS", "HTXNCS", "FWEXL",
        "HTXCL", "HTXNCL", "MEU", "OLD", "FWA", "PMF", "TRA", "FWEU", "IREQ", "IRHH", "LOBDV", "LTBDV",
        "TPW", "WAVFWES", "WAVHH", "WAVTES", "TTHH", "TTEQ"
    ]

    # Set building parameters
    reader = QBuildingsReader()
    qbuildings_data = reader.read_csv(buildings_filename='buildings.csv', nb_buildings=2)

    # Select clustering options for weather data
    cluster = {'Location': 'Geneva', 'Attributes': ['T', 'I', 'W'], 'Periods': 10, 'PeriodDuration': 24}

    df_building_units = pd.read_csv(r'C:\Users\Administrator\Desktop\REHO_LCA_integration\REHO\reho\data\infrastructure\building_units.csv')
    df_district_units = pd.read_csv(r'C:\Users\Administrator\Desktop\REHO_LCA_integration\REHO\reho\data\infrastructure\district_units.csv')
    df_grids = pd.read_csv(r'C:\Users\Administrator\Desktop\REHO_LCA_integration\REHO\reho\data\infrastructure\grids.csv')

    # DataFrame to store X_min and X_max for each indicator
    df_results = pd.DataFrame(index=['X_min', 'X_max'], columns=INDICATORS)

    for normalized_indicator in INDICATORS:

        X_min = float('inf')
        X_max = float('-inf')

        for indicator in INDICATORS:

            # Set scenario
            scenario = {
                'Objective': indicator,
                'name': 'totex',
                'exclude_units': [],
                'enforce_units': []
            }

            # Initialize available units and grids
            grids = infrastructure.initialize_grids()
            units = infrastructure.initialize_units(scenario, grids)

            # Set method options
            method = {'building-scale': True, 'save_lca': True}

            # Run optimization
            reho = REHO(
                qbuildings_data=qbuildings_data,
                units=units,
                grids=grids,
                cluster=cluster,
                scenario=scenario,
                method=method,
                solver="gurobi"
            )
            reho.single_optimization()

            # Update X_min and X_max
            value = reho.results['totex'][0]['df_lca_Performance'].loc['Network', normalized_indicator]
            if X_min > value:
                X_min = value
            if X_max < value:
                X_max = value

        # Store results in the DataFrame
        df_results.loc['X_min', normalized_indicator] = X_min
        df_results.loc['X_max', normalized_indicator] = X_max

    # Print the results DataFrame
    print(df_results)

    # Save the results to a CSV file
    df_results.to_csv('X_min_X_max_results.csv')

