using MPI
MPI.Init()
comm = MPI.COMM_WORLD
using PerforatedCylinder

# Paths
const project_root = "../.."
const data_dir = project_root * "/data"
const OVERWRITE = true

# Define cases
using DelimitedFiles
println("calling meshes...")
mesh_cases = readdlm("generated_meshes.txt")
# cases are of shape "D$D2-Rt$Rt2-n$num_perforations2-β$β2-α$α2 --> add velo and dt
# ------------------------------------------------------------------------------------------------------

# Set filenames
np = MPI.Comm_size(comm)
case_id = parse(Int,ENV["CASE_ID"])
casename = mesh_cases[case_id]
mesh_file = casename * ".msh"
vtks_path = ENV["PerforatedCylinder_VTKS"]
output_path = joinpath(vtks_path,"results_"*casename)
# if isdir(output_path)
#   if MPI.Comm_rank(comm)==0
#     println("Existing case. Exiting execution without computing.")
#   end
#   MPI.Finalize()
#   return nothing
# end
MPI.Barrier(comm)
if MPI.Comm_rank(comm)==0
  rm(output_path,force=true, recursive=true)
  mkdir(output_path)
  println("Casename: $casename")
  println("mesh_file: ", mesh_file)
  println("output_path: ", output_path)
  println("Running case " * casename)
end
MPI.Barrier(comm)

# Run case
PerforatedCylinder.main_parallel(np;
  mesh_file=mesh_file,
  vtk_outpath=output_path,
  Δt=0.1,
  tf=100,
  Δtout=0.2
)

MPI.Finalize()