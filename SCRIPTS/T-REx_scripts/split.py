import os
import getopt
import sys

'''
def split_ms_file(input_file, output_dir, flag):
    """
    Splits an ms file with multiple simulations into individual files.

    Args:
        input_file (str): Path to the input ms file.
        output_dir (str): Directory where output files will be saved.

    Returns:
        None
    """
    # Ensure the output directory exists
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)


    with open(input_file, 'r') as f:
        lines = f.readlines()

    # Extract the command from the first line
    command_line = lines[0].strip()
    simulation_data = []
    simulation_count = 0

    for line in lines[1:]:
        line = line.strip()
        if line.startswith("segsites"):
            # If we've collected data for a previous simulation, save it
            if simulation_data:
                simulation_count += 1
                output_file = os.path.join(output_dir, "{}_{}.ms".format(flag, simulation_count))
                with open(output_file, 'w') as out_f:
                    out_f.write(command_line + "\n")  # Write the command line
                    out_f.write("\n".join(simulation_data) + "\n")  # Write the simulation data
                simulation_data = []  # Reset for the next simulation

        # Collect lines for the current simulation
        simulation_data.append(line)

    # Save the last simulation if any
    if simulation_data:
        simulation_count += 1
        output_file = os.path.join(output_dir, "{}_{}.ms".format(flag, simulation_count))
        with open(output_file, 'w') as out_f:
            out_f.write(command_line + "\n")
            out_f.write("\n".join(simulation_data) + "\n")

    print("Split {} simulations into {}".format(simulation_count, output_dir))
'''
def split_ms_file(input_file, output_dir, flag):
    """
    Splits an ms file with multiple simulations into individual files.

    Args:
        input_file (str): Path to the input ms file.
        output_dir (str): Directory where output files will be saved.
        flag (str): Prefix for output files.

    Returns:
        None
    """
    # Ensure the output directory exists
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)

    with open(input_file, 'r') as f:
        lines = f.readlines()

    # Extract the command from the first line
    command_line = lines[0].strip()
    simulation_data = []
    simulation_count = 0
    is_collecting = False  # Tracks if we are collecting simulation data
    print(flag)

    for line in lines[1:]:
        line = line.strip()

        if line.startswith("segsites"):
            # Save the previous simulation if any
            if simulation_data:
                simulation_count += 1
                output_file = os.path.join(output_dir, "{}_{}.ms".format(flag, simulation_count))
                with open(output_file, 'w') as out_f:
                    out_f.write(command_line + "\n")  # Write the command line
                    out_f.write("\n".join(simulation_data) + "\n")  # Write the simulation data
                simulation_data = []  # Reset for the next simulation

            is_collecting = True  # Start collecting for the new simulation

        # Collect lines for the current simulation
        if is_collecting:
            simulation_data.append(line)

    # Save the last simulation if any
    if simulation_data:
        simulation_count += 1
        output_file = os.path.join(output_dir, "{}_{}.ms".format(flag, simulation_count))
        with open(output_file, 'w') as out_f:
            out_f.write(command_line + "\n")
            out_f.write("\n".join(simulation_data) + "\n")

    print("Split {} simulations into {}".format(simulation_count, output_dir))


def main(argv):
	
    opts, ars = getopt.getopt(argv, "i:o:f:", ["inputpath=", "outputpath=", "flag="])
	
    for opt, arg in opts:
        if opt == '--help':
#			help()
            sys.exit()
        elif opt in ("-i", "--inputpath"):
            input_file = arg
        elif opt in ("-o", "--outputpath"):
            output_dir = arg
        elif opt in ("-f", "--flag"):
            flag = arg
    split_ms_file(input_file, output_dir, flag)		

# Example usage
#input_file = "input.ms"  # Replace with your input file path
#output_dir = "output_simulations"  # Replace with your desired output directory
#split_ms_file(input_file, output_dir)
if __name__ == "__main__":
    main(sys.argv[1:])

