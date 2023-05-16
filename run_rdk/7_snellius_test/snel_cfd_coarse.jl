using MPI
MPI.Init()
comm = MPI.COMM_WORLD
using PerforatedCylinder

# Paths
const OVERWRITE = true

# Set filenames
np = MPI.Comm_size(comm)
casename = "tmp_coarse"
mesh_file = casename * ".msh"
vtks_path = ENV["PerforatedCylinder_VTKs"]
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

t_initial = time()
PerforatedCylinder.main_parallel(np;
  mesh_file=mesh_file,
  vtk_outpath=output_path,
  Δt=0.1,
  tf=1,
  Δtout=0.2,
)

t_final = time()
ElapsedTime = t_final - t_initial
using DelimitedFiles
writedlm("SingleSecondExecutionTime_np$np.txt", ElapsedTime)

MPI.Finalize()
