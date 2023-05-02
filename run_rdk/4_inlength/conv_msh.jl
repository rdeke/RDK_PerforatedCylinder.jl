using PerforatedCylinder

# Paths
const project_root = "../.."
const data_dir = project_root * "/data"
const OVERWRITE = true

# Define cases
println("Generating meshes...")
nR_L = 7 .+ [-0.5, -0.3, -0.1, 0.1, 0.3, 0.5, 0.7, 0.9, 1.1]
mesh_cases = PerforatedCylinder.generate_meshes(; nR_L=nR_L, do_mesh=true)
# cases are of shape "D$D2-Rt$Rt2-n$num_perforations2-β$β2-α$α2 --> add velo and dt

using DelimitedFiles
writedlm("generated_meshes.txt", mesh_cases)
