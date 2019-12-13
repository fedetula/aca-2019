import sys

if (len(sys.argv) != 3):
    print("Usage: __file__ filename_in filename_out")
    exit()

with open(sys.argv[1], 'r') as f_in, open(sys.argv[2], 'w') as f_out:
     for line in f_in.readlines():
         if line.startswith("@"):
             continue
         hexs = line.split()
         [f_out.write(''.join(hexs[i:i+4][::-1]) + "\n") for i in range(0, len(hexs), 4)]

