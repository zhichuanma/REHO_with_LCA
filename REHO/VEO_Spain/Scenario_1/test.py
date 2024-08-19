from reho.model.reho import *
import pandas as pd

if __name__ == '__main__':

    # Set building parameters
    # Load your buildings from a csv file instead of reading the database
    reader = QBuildingsReader()
    qbuildings_data = reader.read_csv(buildings_filename='VEO_Spain.csv', nb_buildings=3)

    # Select clustering options for weather data
    cluster = {'Location': 'Spain', 'Attributes': ['T', 'I', 'W'], 'Periods': 10, 'PeriodDuration': 24}

    # Set scenario
    scenario = dict()
    scenario['Objective'] = 'TOTEX'
    scenario['name'] = 'totex'
    scenario['exclude_units'] = []
    scenario['enforce_units'] = []
    scenario["specific"] = ["enforce_DHN"]

    # Initialize available units and grids
    # grids = infrastructure.initialize_grids(file = "../../../../../reho/data/infrastructure/grids.csv")
    grids = infrastructure.initialize_grids({'Electricity': {},
                                             'NaturalGas': {},
                                             'Wood': {},
                                             'Oil': {},
                                             'Heat': {}
                                             })
    units = infrastructure.initialize_units(scenario, grids, district_data=True)

    # Set specific parameters
    # specify the temperature of the DHN
    parameters = {'T_DHN_supply_cst': np.repeat(75.0, 3), "T_DHN_return_cst": np.repeat(50.0, 3), "area_district": 30819.341}

    # Set method options
    method = {'building-scale': True, 'DHN_CO2': False}

    # Run optimization
    reho = REHO(qbuildings_data=qbuildings_data, units=units, grids=grids, cluster=cluster, scenario=scenario, method=method, parameters=parameters, solver="gurobi")
    reho.get_DHN_costs()  # run one optimization forcing DHN to find costs DHN connection per house
    reho.single_optimization()  # run optimization with DHN costs

    unfixed_file = reho.results['totex'][0]['df_Unit']
    unfixed_file.to_csv('./units_files/unfixed.csv', index=False)


    # Save results
    reho.save_results(format=['xlsx', 'pickle'], filename='test_calibration')

'''
    # Run a simulation with the current situation
    reho.df_fix_Units = reho.results['totex'][0]["df_Unit"]  # load data on the capacity of units

    # reho.df_fix_Units.to_csv('capacity.csv', index=True)
    df = pd.read_csv('capacity.csv', index_col = 0)
    reho.df_fix_Units = df

    # reho.fix_units_list = ['ThermalSolar', 'HeatPump_Air', 'HeatPump_Geothermal', 'NG_Boiler']  # select the ones being fixed

    reho.fix_units_list=['ThermalSolar', 'NG_Boiler', 'OIL_Boiler']

    reho.scenario['Objective'] = 'TOTEX'
    reho.scenario['name'] = 'fixed'

    reho.method['fix_units'] = True  # select the method fixing the unit sizes
    reho.get_DHN_costs()
    reho.single_optimization()
'''


