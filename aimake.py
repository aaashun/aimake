#! /usr/bin/python

import sys,os,platform,optparse
#from optparse import OptionParser

def get_aimake_home():
    return os.path.split(os.path.realpath(__file__))[0]

def get_supported_target_platforms(aimake_home):

    supported_target_platforms = []
    for _name in os.listdir(aimake_home):
        if os.path.isdir(aimake_home+"/"+_name) and not _name.startswith("."):
            supported_target_platforms.append(_name)

    if len(supported_target_platforms) == 0:
        print("Error: there's no supported target platforms, please reinstall aimake")
        exit()

    return supported_target_platforms

def get_host_platform():
    if platform.system() == "Linux":
        return "linux"
    elif platform.system() == "Windows":
        return "windows"
    elif platform.system() ==  "Darwin":
        return "macos"

    return ""

def get_options_and_args():

    supported_target_platforms = get_supported_target_platforms(get_aimake_home())
    host_platform = get_host_platform()

    parser = optparse.OptionParser()
    parser.add_option("-t", "--target-platform", dest="target_platform", help="supported target platforms: " + ", ".join(supported_target_platforms), default=host_platform)
    parser.add_option("-f", "--aimakefile", dest="aimakefile", default="aimakefile", help="specify aimakefile")

    (options, args) = parser.parse_args()
    options.aimakefile = os.path.realpath(options.aimakefile)

    if options.target_platform not in supported_target_platforms:
        print("unsupported target platform: " + options.target_platform)
        exit()

    if not os.path.exists(options.aimakefile):
        print("can not find aimakefile")
        exit()

    return (options, args)

if __name__=="__main__":

    (options, args) = get_options_and_args()
    os.system("make  -f " + get_aimake_home() + "/main.mk"  \
            + " TARGET_PLATFORM=" + options.target_platform \
            + " AIMAKEFILE="      + options.aimakefile      \
            + " AIMAKE_HOME="     + get_aimake_home()       \
            + " LOCAL_PATH="      + os.getcwd()             \
            + " " + " ".join(args))
