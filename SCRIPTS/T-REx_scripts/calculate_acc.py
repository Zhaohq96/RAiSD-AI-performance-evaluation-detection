import pandas as pd
import argparse
# Load the CSV file

parser = argparse.ArgumentParser(description= 'Calculate accuracy')
parser.add_argument('file_path',type=str, help= 'Input file path')
args = parser.parse_args()
file_path = args.file_path  # Replace with your CSV file path

df = pd.read_csv(file_path)

# Extract the predicted labels
predicted_labels = df['Class'].values[:]  # Skip the header

# Define the true labels based on the rule
true_labels = ['Sweep'] * (len(predicted_labels)//2) + ['Neutral'] * (len(predicted_labels)//2)

# Calculate accuracy
correct_predictions = sum(1 for true, pred in zip(true_labels, predicted_labels) if true == pred)
accuracy = correct_predictions / len(true_labels)

#print(len(predicted_labels))
print("Accuracy: {}".format(accuracy))

