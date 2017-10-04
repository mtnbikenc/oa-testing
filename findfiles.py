import os
import re


class FindFiles:
    """
    Finds files with explicit filtering.
    """

    def __init__(self, include_dirs=None, exclude_dirs=None):
        """
        Initializes a FindFiles instance.

        .. note::

           include_dirs and exclude_dirs should NOT start with a slash.
           However, having slashes within the string is fine to denote
           specific paths.

        :param include_dirs: Directories to include in results. If empty then all directories will be included.
        :type include_dirs: list or None
        :param exclude_dirs: Directories to explicitly exclude.
        :type exclude_dirs: list or None
        """
        self.include_dirs = include_dirs or []
        self.exclude_dirs = exclude_dirs or []
        # Add a slash to each item at position 0
        self.include_dirs = list(map(lambda a: os.path.sep + a, self.include_dirs))
        self.exclude_dirs = list(map(lambda a: os.path.sep + a, self.exclude_dirs))

    def find(self, regex='.*'):
        """
        Finds files.

        :param regex: Regular expression string to filter results with.
        :type regex: str
        :returns: Iterator containting matched file paths
        :rtype: generator
        """
        filter = re.compile(regex)

        for root, dirs, files in os.walk('.'):
            root = os.path.realpath(root)

            # Check if we should skip this directory
            if self._should_exclude(root):
                continue

            # Check if we should include the directory
            if self._should_include(root):
                for afile in files:
                    file_path = os.path.join(root, afile)
                    if filter.search(file_path):
                        yield file_path

    def _should_exclude(self, dir):
        """
        Notes if the directory should be excluded.

        :param dir: The directory to investigate.
        :type dir: str
        :returns: True to exclude, otherwise False.
        :rtype: bool
        """
        for exclude in self.exclude_dirs:
            if exclude in dir:
                return True
        return False

    def _should_include(self, dir):
        """
        Notes if the directory should be included.

        :param dir: The directory to investigate.
        :type dir: str
        :returns: True to include, otherwise False.
        :rtype: bool
        """
        # If include_dirs is empty then we assume everything is included
        if len(self.include_dirs) == 0:
            return True

        for include in self.include_dirs:
            if include in dir:
                return True
        return False


if __name__ == '__main__':
    f = FindFiles(
        exclude_dirs=['adhoc', 'files', 'meta', 'test', 'tests', 'vars'],
        include_dirs=['playbooks', 'roles'])

    files = []
    for x in f.find('\.yml$'):
        # print(x)
        files.extend([x])
    print(len(files))
