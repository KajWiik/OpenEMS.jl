module OpenEMS

if !haskey(ENV, "JULIA_PYTHONCALL_EXE")
    ENV["JULIA_PYTHONCALL_EXE"] = joinpath(homedir(), ".local", "openEMS", "venv", "bin", "python")
end

using PythonCall

CSXCAD = pyimport("CSXCAD")
openEMS = pyimport("openEMS")

export CSXCAD, openEMS


# Write your package code here.

end
