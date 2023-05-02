using PerforatedCylinder

# Paths
const project_root = "../.."
const data_dir = project_root * "/data"
const OVERWRITE = true

# Define cases
println("Generating meshes...")
R_L = [3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
mesh_cases = PerforatedCylinder.generate_meshes(; nR_L=R_L, do_mesh=true)
# cases are of shape "D$D2-Rt$Rt2-n$num_perforations2-β$β2-α$α2 --> add velo and dt

using DelimitedFiles
writedlm("generated_meshes.txt", mesh_cases)
