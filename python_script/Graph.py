# -*- coding: utf-8 -*-
r"""(one line description)

This exports: 

  -

This depends on:

  -  

Examples of usage:

  - default usage:

        python -m 

descriptions
""" 
import numpy as np
import sys, os, argparse
# import json, re
# import pathlib
# import subprocess
import numpy as np
# from matplotlib import cm
from matplotlib import pyplot as plt

# directory to the aspect Lab
USRBIN_DIR = os.environ['USRBIN_DIR']
RESULT_DIR = os.path.join(USRBIN_DIR, 'results')

# directory to shilofue
py_DIR = os.path.join(USRBIN_DIR, 'python_script')

class GRAPH_ADJ_LIST():
    '''
    class for graph implemented with the adjacency list
    Attributes:

    '''
    def __init__():
        '''
        initiation
        '''
        self.adj_list = []
        pass
    
    def add():
        '''
        '''
        pass


def main():
    '''
    main function of this module
    Inputs:
        sys.arg[1](str):
            commend
        sys.arg[2, :](str):
            options
    '''
    _commend = sys.argv[1]
    # parse options
    parser = argparse.ArgumentParser(description='Parse parameters')
    parser.add_argument('-i', '--inputs', type=str,
                        default='',
                        help='Some inputs')
    _options = []
    try:
        _options = sys.argv[2: ]
    except IndexError:
        pass
    arg = parser.parse_args(_options)

    # commands
    if _commend == 'foo':
        # example:
        SomeFunction('foo')

# run script
if __name__ == '__main__':
    main()